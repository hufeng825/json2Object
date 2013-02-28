//
//  json2Object.m
//  json2Object
//
//  Created by shawn on 13-2-23.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import "CLJson2Object.h"
#import "CLJSONModel.h"
#import <objc/runtime.h>

@implementation CLJson2Object
+ (NSString *)propertyName:(Ivar)propertyIvar{
    return [NSString stringWithUTF8String:ivar_getName(propertyIvar)];
}
+ (id)JSONObjectForClass:(Class)theClass WithDictionary:(NSDictionary *)jsonData
{
    if (! jsonData) {
        return nil;
    }
    CLJSONModel *model = class_createInstance(theClass, 0);
    NSAssert([model isKindOfClass:CLJSONModel.class], @"class has to be a subclass of CLJSONModel");
    [CLJson2Object parseDictionary:jsonData Class:theClass Target:model];
    return [model autorelease];
}
+ (void)parseDictionary:(NSDictionary *)jsonData Class:(Class)class Target:(CLJSONModel *)jsonModel{
    Class superClass = class_getSuperclass(class);
    if (superClass != NSObject.class) {
        [CLJson2Object parseDictionary:jsonData Class:superClass Target:jsonModel];
    }
    unsigned int outCount, i;
    Ivar *properties = class_copyIvarList(class, &outCount);
    //there is no property difined in the class, return;
    if (outCount == 0) {
        return;
    }
    for (i = 0; i < outCount; i++) {
        Ivar property = properties[i];
        NSString *name = [CLJson2Object propertyName:property];
        fprintf(stdout, "property:%s,type:%s\n", ivar_getName(property),ivar_getTypeEncoding(property));
        id data = jsonData[name];
        if (!data) {
            data = jsonData[[jsonModel jsonKeyForProperty:name]];
        }
        if (data) {
            [CLJson2Object setIvarProperty:property Value:data Target:jsonModel];
        }
    }
    free(properties);
}
+ (void)setIvarProperty:(Ivar)ivar Value:(id)value Target:(CLJSONModel *)target
{
    static const char *charType = "c";
//    static const char *usCharType = "C";    //us : unsigned
    static const char *intType = "i";
    static const char *shortType = "s";
    static const char *longType = "l";
    static const char *longlongType = "q";
    static const char *usIntType = "I";
    static const char *usShortType = "S";
    static const char *usLongType = "L";
    static const char *usLonglongrType = "Q";
    static const char *floatType = "f";
    static const char *doubleType = "d";
    static const char *boolType = "B";
    static const char *cStringType = "*";
    static const char *idType = "@";
    
    static const char *cgPointType = "{CGPoint=\"x\"f\"y\"f}";
    static const char *cgSizeType = "{CGSize=\"width\"f\"height\"f}";
    static const char *cgRectType = "{CGRect=\"origin\"{CGPoint=\"x\"f\"y\"f}\"size\"{CGSize=\"width\"f\"height\"f}}";
    static const char *nsDateType = "@\"NSDate\"";
    static const char *nsStringType = "@\"NSString\"";
//    static const char *dictionaryType = "@\"NSDictionary\"";
//    static const char *mtDictionaryType = "@\"NSMutableDictionary\"";
    const char *type = ivar_getTypeEncoding(ivar);
    size_t size = strlen(type);
    // not basic types,a specific Object type like NSDate,NSArray,etc.
    if (size > 1) {
        if (strcmp(type, nsStringType) == 0 && [value isKindOfClass:[NSString class]]) {
            //most datas are transferred on internet is string, so deal it first
            object_setIvar(target, ivar, value);
        }else if (strcmp(type, cgPointType) == 0 && [value isKindOfClass:[NSDictionary class]]) {
            //CGPoint
            NSDictionary *data = (NSDictionary *)value;
            CLJSONPoint *point = [[CLJSONPoint alloc] init];
            [CLJson2Object parseDictionary:data Class:point.class Target:point];
            CGPoint *varIndex = (CGPoint *)(void **)((char *)target + ivar_getOffset(ivar));
            *varIndex = point.CGPoint;
            [point release];
        }else if (strcmp(type, cgSizeType) == 0 && [value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)value;
            CLJSONSize *size = [[CLJSONSize alloc] init];
            [CLJson2Object parseDictionary:data Class:size.class Target:size];
            CGSize *varIndex = (CGSize *)(void **)((char *)target + ivar_getOffset(ivar));
            *varIndex = size.CGSize;
            [size release];
        }else if (strcmp(type, cgRectType) == 0 && [value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)value;
            CLJSONRect *rect = [[CLJSONRect alloc] init];
            [CLJson2Object parseDictionary:data Class:rect.class Target:rect];
            CGRect *varIndex = (CGRect *)(void **)((char *)target + ivar_getOffset(ivar));
            *varIndex = rect.CGRect;
            [rect release];
        }else if (strcmp(type, nsDateType) == 0) {
            NSDate *date = value;
            if ([value isKindOfClass:[NSNumber class]]) {
                NSTimeInterval interval = ((NSNumber*)value).doubleValue;
                date = [NSDate dateWithTimeIntervalSince1970:interval];
            } else if([value isKindOfClass:[NSString class]]) {
                NSString *name = [CLJson2Object propertyName:ivar];
                NSString *stringFormat = [target dateFormatStringForProperty:name];
                if (stringFormat) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:stringFormat];
                    date = [formatter dateFromString:(NSString *)value];
                    [formatter release];
                }
            }
            object_setIvar(target, ivar, date);
        }else if([value isKindOfClass:[NSDictionary class]]){
            NSString *name = [CLJson2Object propertyName:ivar];
            Class propertyClass =  [target classForProperty:name];
            if (propertyClass) {
                id obj = [CLJson2Object JSONObjectForClass:propertyClass WithDictionary:value];
                object_setIvar(target, ivar, obj);
            }else{
                object_setIvar(target, ivar, value);
            }
        }else if([value isKindOfClass:[NSArray class]]){
            NSString *name = [CLJson2Object propertyName:ivar];
            Class classOfPerproty = [target classForProperty:name];
            if (classOfPerproty == nil) {
                object_setIvar(target, ivar, value);
            }else{
                NSArray *arr = (NSArray *)value;
                NSMutableArray *objs = [NSMutableArray arrayWithCapacity:arr.count];
                for (NSDictionary *dict in arr) {
                    id obj = [CLJson2Object JSONObjectForClass:classOfPerproty WithDictionary:dict];
                    [objs addObject:obj];
                }
                object_setIvar(target, ivar, objs);
            }
        }else{
            object_setIvar(target, ivar, value);
        }
    } else if(strcmp(type, idType) == 0) {
        object_setIvar(target, ivar, value);
    } else if(strcmp(type, intType) == 0 || strcmp(type, usIntType) == 0) {
        int intValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            intValue = ((NSNumber *)value).intValue;
        } else if([value isKindOfClass:[NSString class]]) {
            intValue = ((NSString *)value).intValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(int **)&intValue);
    } else if(strcmp(type, shortType) == 0 || strcmp(type, usShortType) == 0) {
        short shortValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            shortValue = ((NSNumber *)value).shortValue;
        } else if([value isKindOfClass:[NSString class]]) {
            shortValue = ((NSString *)value).intValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(short **)&shortValue);
    } else if(strcmp(type, longType) == 0 || strcmp(type, usLongType) == 0) {
        long longValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            longValue = ((NSNumber *)value).longValue;
        } else if([value isKindOfClass:[NSString class]]) {
            longValue = ((NSString *)value).intValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(long **)&longValue);
    } else if(strcmp(type, longlongType) == 0 || strcmp(type, usLonglongrType) == 0) {
        long long longlongValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            longlongValue = ((NSNumber *)value).longLongValue;
        } else if([value isKindOfClass:[NSString class]]) {
            longlongValue = ((NSString *)value).longLongValue;
        }
        long long *varIndex = (long long *)(void **)((char *)target + ivar_getOffset(ivar));
        *varIndex = longlongValue;
    } else if(strcmp(type, floatType) == 0) {
        float floatValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            floatValue = ((NSNumber *)value).floatValue;
        } else if([value isKindOfClass:[NSString class]]) {
            floatValue = ((NSString *)value).floatValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(float **)&floatValue);
    } else if(strcmp(type, doubleType) == 0) {
        double doubleValue = 0;
        if ([value isKindOfClass:[NSNumber class]]) {
            doubleValue = ((NSNumber *)value).doubleValue;
        } else if([value isKindOfClass:[NSString class]]) {
            doubleValue = ((NSString *)value).doubleValue;
        }
        double *varIndex = (double *)(void **)((char *)target + ivar_getOffset(ivar));
        *varIndex = doubleValue;
    } else if(strcmp(type, boolType) == 0) {
        bool boolValue = false;
        if ([value isKindOfClass:[NSNumber class]]) {
            boolValue = ((NSNumber *)value).boolValue;
        } else if([value isKindOfClass:[NSString class]]) {
            boolValue = ((NSString *)value).boolValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(bool **)&boolValue);
    } else if(strcmp(type, charType) == 0) {
        //BOOL
        BOOL boolValue = NO;
        if ([value isKindOfClass:[NSNumber class]]) {
            boolValue = ((NSNumber *)value).boolValue;
        } else if([value isKindOfClass:[NSString class]]) {
            boolValue = ((NSString *)value).boolValue;
        }
        object_setInstanceVariable(target, ivar_getName(ivar), *(BOOL **)&boolValue);
    } else if(strcmp(type, cStringType) == 0) {
        if([value isKindOfClass:[NSString class]]) {
            NSString *name = [CLJson2Object propertyName:ivar];
            const char *chars = [((NSString *)value) cStringUsingEncoding:[target encodeForProperty:name]];
            object_setInstanceVariable(target, ivar_getName(ivar), *(char **)&chars);
        }
    }
}
/*
 c A char
 i An int
 s A short
 l A long
 l is treated as a 32-bit quantity on 64-bit programs.
 q A long long
 C An unsigned char
 I An unsigned int
 S An unsigned short
 L An unsigned long
 Q An unsigned long long
 f A float
 d A double
 B A C++ bool or a C99 _Bool
 * A character string (char *)
 */
@end
