//
//  CLJSONModel.h
//  json2obj
//
//  Created by shawn on 13-2-21.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CLJSONModel : NSObject
//if property name is different from key of data dictionary,return the key
- (NSString *)jsonKeyForProperty:(NSString *)propertyName;
//if there is a array or dictionary property in the class ,return specific class type
- (Class)classForProperty:(NSString *)propertyName;
//default utf-8
- (NSStringEncoding)encodeForProperty:(NSString *)propertyName;
//format string used for NSDateFormatter,like 'yyyy/dd/MM'
- (NSString *)dateFormatStringForProperty:(NSString *)propertyName;
@end

@interface CLJSONPoint : CLJSONModel
@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
- (CGPoint)CGPoint;
@end

@interface CLJSONSize : CLJSONModel
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
- (CGSize)CGSize;
@end

@interface CLJSONRect : CLJSONModel
@property(nonatomic,retain) CLJSONPoint *origin;
@property(nonatomic,retain) CLJSONSize *size;
- (CGRect)CGRect;
@end
