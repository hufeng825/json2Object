//
//  json2Object.h
//  json2Object
//
//  Created by shawn on 13-2-23.
//  Copyright (c) 2013年 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLJson2Object : NSObject
//parse a dictionary to a instance of class
//the class has to be a subclass of CLJSONModel
+ (id)JSONObjectForClass:(Class)theClass WithDictionary:(NSDictionary *)jsonData;
@end
