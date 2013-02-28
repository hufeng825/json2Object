json2Object
===========

parse  json dictionary to object

you can parse json string to a dictionary use lib like SBJson,then this will parse it to object

variable types supported 

Object                    Dictionary
NSString                  NSString
int,NSInteger             NSNumber
float                     NSNumber
double                    NSNumber
long                      NSNumber
char *                    NSString default encoding:UTF-8 or return one by overwrite method:
                                  - (NSStringEncoding)encodeForProperty:(NSString *)propertyName
CGPoint                   NSDictionary must like: {"x":123,"y":234}
CGSize                    NSDictionary must like: {"width":123,"height":234}
CGRect                    NSDictionary must like: {"origin":{"x":123,"y":234},"size":{"width":123,"height":234}}
NSDate                    NSNumber the interval since 1970
NSDate                    NSString  need give a format string by overwrite method:
                                     - (NSString *)dateFormatStringForProperty:(NSString *)propertyName
NSArray                   NSArray if want to parse the object in array, return the type by overwrite method:
                                    - (Class)classForProperty:(NSString *)propertyName
Object                    NSDictionary  return the type by overwrite method:
                                    - (Class)classForProperty:(NSString *)propertyName
                                    
                                    
if the key of dictionary is different from the name you defined in class, return one by overwrite method:- (NSString *)jsonKeyForProperty:(NSString *)propertyName.
