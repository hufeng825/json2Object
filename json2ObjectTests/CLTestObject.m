//
//  CLTestObject.m
//  json2obj
//
//  Created by shawn on 13-2-21.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import "CLTestObject.h"

@implementation CLTestObject
- (void)dealloc
{
    NSLog(@"------------------------,CLTestObject dealloc");
    [super dealloc];
}
+ (NSDictionary *)dictionaryData
{
    NSDictionary *innerClass1 = @{@"string": @"testin001",
                                  @"intValue": @(827700),
                                  @"nsInteger": @(943300)};
    NSDictionary *innerClass2 = @{@"string": @"testin11",
                                  @"intValue": @(827711),
                                  @"nsInteger": @(943311)};
    return @{
             @"string": @"test",
             @"intValue": @(123),
             @"nsInteger": @(234),
             @"cgFloat": @(123.12),
             @"doubleValue": @(456.76),
             @"date": [NSDate date],
             @"intervalDate":@(1362020369.219931),
             @"stringDate":@"1982-10-06",   // -:) my birthday  
             @"array": @[
                     @{@"string": @"testin1",
                       @"intValue": @(123444),
                       @"nsInteger": @(234555)},
                     @{@"string": @"testin2",
                       @"intValue": @(123777),
                       @"nsInteger": @(234888)}],
             @"mutableArray": @[
                     @{@"string": @"testin11",
                       @"intValue": @(1277),
                       @"nsInteger": @(23433)},
                     @{@"string": @"testin22",
                       @"intValue": @(555),
                       @"nsInteger": @(7667)}],
             @"dictionary": @{
                     @"inner":@{@"string": @"testin13",
                                @"intValue": @(8277),
                                @"nsInteger": @(9433)}},
             @"mutableDictionary":  @{
                     @"inner":@{@"string": @"testin14",
                                @"intValue": @(8377),
                                @"nsInteger": @(4433)}},
             @"boolValue": @"1",
             @"cString" :  @"CSTRING",
             @"longValue" : @(786868),
             @"longlongValue" : @(989898989898989),
             @"cgPoint" : @{@"x" : @(232.32), @"y" : @(44.56)},
             @"innerClass":@{@"string": @"testin13",
                        @"intValue": @(8277),
                        @"nsInteger": @(9433)},
             @"arrayClass":@[innerClass1,innerClass2],
             @"subIntValue": @(909)
             };
}
- (Class)classForProperty:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"_innerClass"]) {
        return [CLInner class];
    }else if ([propertyName isEqualToString:@"_arrayClass"]){
        return [CLInner class];
    }
    return nil;
}
- (NSString *)dateFormatStringForProperty:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"_stringDate"]) {
        return @"yyyy-MM-dd";
    }
    return [super dateFormatStringForProperty:propertyName];
}
- (NSString *)description
{
    NSMutableString *result = [NSMutableString stringWithFormat:@"string:%@,int:%d,integer:%d,CGFloat:%f,double:%f,date:%@,array:%@,mutableArr:%@,dict:%@,mutableDict:%@,bool:%d",
                               self.string,
                               self.intValue,
                               self.nsInteger,
                               self.cgFloat,
                               self.doubleValue,
                               self.date,
                               self.array,
                               self.mutableArray,
                               self.dictionary,
                               self.mutableDictionary,
                               self.boolValue];
    return result;
}
- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[CLTestObject class]]) {
        return NO;
    }
    CLTestObject *clto = (CLTestObject *)object;
    BOOL a =  (!self.string && !clto.string) ? YES : [self.string isEqual:clto.string];
    BOOL b =  self.intValue == clto.intValue;
    BOOL c =  self.nsInteger == clto.nsInteger;
    BOOL d =  self.cgFloat == clto.cgFloat;
    BOOL e =  self.doubleValue == clto.doubleValue;
    BOOL f =  (!self.date && !clto.date) ? YES : [self.date isEqual:clto.date];
    BOOL g =  (!self.array && !clto.array) ? YES : [self.array isEqual:clto.array];
    BOOL h =  (!self.mutableArray && !clto.mutableArray) ? YES : [self.mutableArray isEqual:clto.mutableArray];
    BOOL i =  (!self.dictionary && !clto.dictionary) ? YES : [self.dictionary isEqual:clto.dictionary];
    BOOL j =  (!self.mutableDictionary && !clto.mutableDictionary) ? YES : [self.mutableDictionary isEqual:clto.mutableDictionary];
    BOOL k =  self.boolValue == clto.boolValue;
    return a && b && c && d && e && f && g && h && i && j && k;
}
@end
@implementation CLInner

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || [object isKindOfClass:[CLInner class]]) {
        return NO;
    }
    CLInner *inner = (CLInner *)object;
    return self.nsInteger == inner.nsInteger;
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"string:%@,int:%d,integer:%d",self.string,self.intValue,self.nsInteger];
}
@end
@implementation CLSubObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || [object isKindOfClass:[CLSubObject class]]) {
        return NO;
    }
    CLSubObject *sub = (CLSubObject *)object;
    return self.nsInteger == sub.subIntValue;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,subIntValue:%d",[super description],self.subIntValue];
}

@end
