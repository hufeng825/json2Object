//
//  CLTestObject.h
//  json2obj
//
//  Created by shawn on 13-2-21.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "CLJSONModel.h"

@class CLInner;
@interface CLTestObject : CLJSONModel
@property(nonatomic,copy)NSString *string;
@property(nonatomic,assign)int intValue;
@property(nonatomic,assign)NSInteger nsInteger;
@property(nonatomic,assign)float cgFloat;
@property(nonatomic,assign)double doubleValue;
@property(nonatomic,retain)NSDate *date;
@property(nonatomic,retain)NSDate *intervalDate;
@property(nonatomic,retain)NSDate *stringDate;
@property(nonatomic,retain)NSArray *array;
@property(nonatomic,retain)NSMutableArray *mutableArray;
@property(nonatomic,retain)NSDictionary *dictionary;
@property(nonatomic,retain)NSMutableDictionary *mutableDictionary;
@property(nonatomic,assign)bool boolValue;
@property(nonatomic,assign)char *cString;
@property(nonatomic,assign)long longValue;
@property(nonatomic,assign)long long longlongValue;
@property(nonatomic,assign)CGPoint cgPoint;
@property(nonatomic,assign)CGSize cgSize;
@property(nonatomic,assign)CGRect cgRect;
@property(nonatomic,retain)CLInner *innerClass;
@property(nonatomic,retain)NSArray *arrayClass;

+ (NSDictionary *)dictionaryData;
@end

@interface CLInner : CLJSONModel
@property(nonatomic,copy)NSString *string;
@property(nonatomic,assign)int intValue;
@property(nonatomic,assign)NSInteger nsInteger;
@end

@interface CLSubObject : CLTestObject
@property(nonatomic,assign)int subIntValue;
@end
