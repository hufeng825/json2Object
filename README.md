json2Object
===========

parse  json dictionary to object

you can parse json string to a dictionary use lib like SBJson,then this will parse it to object

variable types supported 

(Object)  ---                  (Dictionary) <br>
NSString     ---               NSString  <br><br>
int,NSInteger     ---          NSNumber<br><br>
float              ---         NSNumber<br><br>
double              ---        NSNumber<br><br>
long               ---         NSNumber<br><br>
char *            ---          NSString default encoding:UTF-8 or return one by overwrite method:<br>
                                  - (NSStringEncoding)encodeForProperty:(NSString *)propertyName<br><br>
CGPoint           ---          NSDictionary must like: {"x":123,"y":234}<br><br>
CGSize             ---         NSDictionary must like: {"width":123,"height":234}<br><br>
CGRect            ---          NSDictionary must like: {"origin":{"x":123,"y":234},"size":{"width":123,"height":234}}<br><br>
NSDate             ---         NSNumber the interval since 1970<br>
NSDate             ---         NSString  need give a format string by overwrite method:<br>
                                     - (NSString *)dateFormatStringForProperty:(NSString *)propertyName<br><br>
NSArray           ---          NSArray if want to parse the object in array, return the type by overwrite method:<br>
                                    - (Class)classForProperty:(NSString *)propertyName<br><br>
Object             ---         NSDictionary  return the type by overwrite method:<br>
                                    - (Class)classForProperty:(NSString *)propertyName<br><br><br>
                                    
                                    
if the key of dictionary is different from the name you defined in class, return one by overwrite method:<br>- (NSString *)jsonKeyForProperty:(NSString *)propertyName.
