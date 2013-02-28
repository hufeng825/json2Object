//
//  json2ObjectTests.m
//  json2ObjectTests
//
//  Created by shawn on 13-2-23.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CLJson2Object.h"
#import "CLJSONModel.h"
#import "CLTestObject.h"
#import <objc/runtime.h>

@interface json2ObjectTests : SenTestCase
@property(nonatomic,retain)NSDictionary *data;
@end

@implementation json2ObjectTests

- (void)setUp
{
    [super setUp];
    self.data = [CLTestObject dictionaryData];
    char c = '\r';
    NSLog(@"%d",[[NSCharacterSet controlCharacterSet] characterIsMember:c]);
}
-(void) dumpCharacterSet:(NSString *)name
{
    unichar idx;
    NSCharacterSet *cset = [NSCharacterSet performSelector: NSSelectorFromString(name)];
    
    printf("Character set (0-127): %s\n7-Bit: ", [name UTF8String]);
    
    for( idx = 0; idx < 256; idx++ )
    {
        if ( 128 == idx ) {
            printf( "\n8-Bit: " );
        }
        
        //Returns a Boolean value that indicates whether a given character is in the receiver.
        if ([cset characterIsMember: idx])
        {
            //判断字符c是否为可打印字符（含空格）
            if ( isprint(idx) ) {
                printf( "%c ", idx);
            }
            else {
                printf( "x ", idx);
            }
        }
    }
    printf("\n\n");
}
- (void)tearDown
{
    self.data = nil;
    [super tearDown];
}

- (void)testParseString
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    STAssertEqualObjects(res.string, self.data[@"string"], @"String value did not be parsed");
}
- (void)testParseInt
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *inValue = self.data[@"intValue"];
    STAssertTrue((res.intValue == inValue.intValue), @"int value did not be parsed");
}
- (void)testParseInteger
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *nsInteger = self.data[@"nsInteger"];
    STAssertTrue((res.nsInteger == nsInteger.integerValue), @"integer value did not be parsed");
}
- (void)testParseFloat
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *cgFloat = self.data[@"cgFloat"];
    STAssertTrue((res.cgFloat == cgFloat.floatValue), @"float value did not be parsed");
}
- (void)testParseDouble
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *doubleValue = self.data[@"doubleValue"];
    double sv = res.doubleValue - doubleValue.doubleValue;
    STAssertTrue((sv > -0.000001 && sv < 0.000001), @"double value did not be parsed");
}
- (void)testParseBool
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSString *boolValue = self.data[@"boolValue"];
    STAssertTrue((res.boolValue == boolValue.boolValue), @"bool value did not be parsed");
}
- (void)testParseCString
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSString *cString = self.data[@"cString"];
    STAssertTrue((strcmp([cString cStringUsingEncoding:NSUTF8StringEncoding], res.cString) == 0), @"bool value did not be parsed");
}
- (void)testParseLong
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *longValue = self.data[@"longValue"];
    STAssertTrue((res.longValue == longValue.longValue), @"Long value did not be parsed");
}
- (void)testParseLongLong
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSNumber *longlongValue = self.data[@"longlongValue"];
    STAssertTrue((res.longlongValue == longlongValue.longLongValue), @"Long Long value did not be parsed");
}
- (void)testParseDate
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSDate *date = self.data[@"date"];
    STAssertTrue(([date isEqualToDate:res.date]), @"Date value did not be parsed");
    NSTimeInterval interval = ((NSNumber *)self.data[@"intervalDate"]).doubleValue;
    NSTimeInterval resInterval = [res.intervalDate timeIntervalSince1970];
    STAssertTrue((resInterval == interval), @"Interval Date value did not be parsed");
    NSString *stringDate = self.data[@"stringDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[res dateFormatStringForProperty:@"_stringDate"]];
    NSString *pDate = [formatter stringFromDate:res.stringDate];
    [formatter release];
    STAssertTrue(([pDate isEqualToString:stringDate]), @"String Date value did not be parsed");
}
- (void)testParseCGPoint
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSDictionary *cgPoint = self.data[@"cgPoint"];
    CGFloat x = ((NSNumber *)cgPoint[@"x"]).floatValue;
    CGFloat y = ((NSNumber *)cgPoint[@"y"]).floatValue;
    STAssertTrue((res.cgPoint.x == x && res.cgPoint.y == y), @"CGPoint value did not be parsed");
}
- (void)testParseCGSize
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSDictionary *cgSize = self.data[@"cgSize"];
    CGFloat width = ((NSNumber *)cgSize[@"width"]).floatValue;
    CGFloat height = ((NSNumber *)cgSize[@"height"]).floatValue;
    STAssertTrue((res.cgSize.width == width && res.cgSize.height == height), @"CGSize value did not be parsed");
}
- (void)testParseCGRect
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSDictionary *cgRect = self.data[@"cgRect"];
    CGFloat x = ((NSNumber *)cgRect[@"origin"][@"x"]).floatValue;
    CGFloat y = ((NSNumber *)cgRect[@"origin"][@"y"]).floatValue;
    CGFloat width = ((NSNumber *)cgRect[@"size"][@"width"]).floatValue;
    CGFloat height = ((NSNumber *)cgRect[@"size"][@"height"]).floatValue;
    STAssertTrue((res.cgRect.origin.x == x && res.cgRect.origin.y == y && res.cgRect.size.width == width && res.cgRect.size.height == height), @"CGPoint value did not be parsed");
}
- (void)testParseInnerClassInDictionary
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSDictionary *dictionary = self.data[@"innerClass"];
    NSString *string = dictionary[@"string"];
    int intValue = ((NSNumber *)dictionary[@"intValue"]).intValue;
    NSInteger nsInteger = ((NSNumber *)dictionary[@"nsInteger"]).intValue;
    STAssertTrue(([res.innerClass.string isEqualToString:string] && res.innerClass.intValue == intValue && res.innerClass.nsInteger == nsInteger), @"Inner class value did not be parsed");
}
- (void)testParseInnerClassInArray
{
    id parseObj = [CLJson2Object JSONObjectForClass:[CLTestObject class] WithDictionary:self.data];
    STAssertTrue([parseObj isKindOfClass:[CLTestObject class]], @"Not return a same kinda object");
    CLTestObject *res = (CLTestObject *)parseObj;
    NSArray *array = self.data[@"arrayClass"];
    NSDictionary *dictionary = array[0];
    NSString *string = dictionary[@"string"];
    int intValue = ((NSNumber *)dictionary[@"intValue"]).intValue;
    NSInteger nsInteger = ((NSNumber *)dictionary[@"nsInteger"]).intValue;
    CLInner *inner = res.arrayClass[0];
    STAssertTrue(([inner.string isEqualToString:string] && inner.intValue == intValue && inner.nsInteger == nsInteger), @"Inner classes in array value did not be parsed");
    NSDictionary *dictionary1 = array[1];
    NSString *string1 = dictionary1[@"string"];
    int intValue1 = ((NSNumber *)dictionary1[@"intValue"]).intValue;
    NSInteger nsInteger1 = ((NSNumber *)dictionary1[@"nsInteger"]).intValue;
    CLInner *inner1 = res.arrayClass[1];
    STAssertTrue(([inner1.string isEqualToString:string1] && inner1.intValue == intValue1 && inner1.nsInteger == nsInteger1), @"Inner classes in array value did not be parsed");
}
@end
