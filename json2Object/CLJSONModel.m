//
//  CLJSONModel.m
//  json2obj
//
//  Created by shawn on 13-2-21.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import "CLJSONModel.h"
#import <objc/runtime.h>

@implementation CLJSONModel
- (NSString *)jsonKeyForProperty:(NSString *)propertyName{
    return [propertyName substringFromIndex:1];
}
- (Class)classForProperty:(NSString *)propertyName
{
    return nil;
}
- (NSStringEncoding)encodeForProperty:(NSString *)propertyName
{
    return NSUTF8StringEncoding;
}
- (NSString *)dateFormatStringForProperty:(NSString *)propertyName{
    return nil;
}
@end

@implementation CLJSONPoint
- (CGPoint)CGPoint
{
    return CGPointMake(self.x, self.y);
}
@end

@implementation CLJSONSize
- (CGSize)CGSize
{
    return CGSizeMake(self.width, self.height);
}
@end

@implementation CLJSONRect

- (void)dealloc
{
    [_origin release];
    [_size release];
    [super dealloc];
}
- (CGRect)CGRect
{
    return (self.origin && self.size) ? CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height) : CGRectZero;
}
@end
