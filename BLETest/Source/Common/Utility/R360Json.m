//
//  R360Json.m
//  Pods
//
//  Created by LiuDequan on 15/5/12.
//
//

#import "R360Json.h"

@implementation NSArray (NSArray_JSONString)

- (NSString *)JSONRepresentation
{
    if ([self isEqual:[NSNull null]] || !self) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end



@implementation NSDictionary (NSDictionary_JSONString)

- (NSString *)JSONRepresentation
{
    if ([self isEqual:[NSNull null]] || !self) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end



@implementation NSString (NSString_JSONObject)

- (id)JSONValue
{
    if ([self isEqual:[NSNull null]] || !self || ![self length]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return json;
}

@end



@implementation NSData (NSData_JSONObject)

- (id)JSONValue
{
    if ([self isEqual:[NSNull null]] || !self || ![self length]) {
        return nil;
    }
    
    NSError *error = nil;
    
    id json =[NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    return json;
}

@end
