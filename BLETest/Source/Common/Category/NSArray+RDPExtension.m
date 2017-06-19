//
//  NSArray+RDPExtension.m
//  R360DP
//
//  Created by LiuDequan on 15/5/13.
//  Copyright (c) 2015年 liudequan. All rights reserved.
//

#import "NSArray+RDPExtension.h"

@implementation NSArray (RDPExtension)
- (NSArray *)head:(NSUInteger)count
{
    if ( [self count] < count  || count == 0  )
    {
        return self;
    }
    else
    {
        NSMutableArray * tempFeeds = [NSMutableArray array];
        for ( NSObject * elem in self )
        {
            [tempFeeds addObject:elem];
            if ( [tempFeeds count] >= count )
                break;
        }
        return tempFeeds;
    }
}

- (NSArray *)tail:(NSUInteger)count
{
    if ( [self count] < count) {
        return self;
    }
    NSRange range;
    range.location = [self count] -count;
    range.length = count;
    return [self subarrayWithRange:range];
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

- (NSString *)strAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return obj ?: @"";
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue] ?: @"";
    }
    
    return @"";
}

- (int)intAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj intValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj intValue];
    }
    
    return 0;
}

- (BOOL)boolAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj boolValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj boolValue];
    }
    
    return NO;
}

- (long)longAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return (long)[(NSString *)obj longLongValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj longValue];
    }
    
    return 0;
}

- (long long)llongAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj longLongValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj longLongValue];
    }
    
    return 0;
}

- (double)doubleAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj doubleValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj doubleValue];
    }
    
    return 0;
}

- (float)floatAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj floatValue];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj floatValue];
    }
    
    return 0;
}

- (NSNumber *)numAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSNumber *number = [[[NSNumberFormatter alloc] init] numberFromString:obj];
        if (number) {
            return number;
        }
    }
    
    return nil;
}

- (NSArray *)arrAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    
    return nil;
}

- (NSDictionary *)dicAt:(NSUInteger)index {
    id obj = [self safeObjectAtIndex:index];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

- (NSUInteger)lastIndex {
    return [self count] - 1;
}

-(NSData*)data
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

@end

#pragma mark -

@implementation NSMutableArray (RDPExtension)

- (NSMutableArray *)pushHead:(NSObject *)obj
{
    if ( obj )
    {
        [self insertObject:obj atIndex:0];
    }
    
    return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
    if ( [all count] )
    {
        for ( NSUInteger i = [all count]; i > 0; --i )
        {
            [self insertObject:[all objectAtIndex:i - 1] atIndex:0];
        }
    }
    
    return self;
}

- (NSMutableArray *)popTail
{
    if ( [self count] > 0 )
    {
        [self removeObjectAtIndex:[self count] - 1];
    }
    
    return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
    if ( [self count] > 0 )
    {
        if ( n >= [self count] )
        {
            [self removeAllObjects];
        }
        else
        {
            NSRange range;
            range.location = [self count] - n;
            range.length =n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
    if ( obj )
    {
        [self addObject:obj];
    }
    
    return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
    if ( [all count] )
    {
        [self addObjectsFromArray:all];
    }
    
    return self;
}

- (NSMutableArray *)popHead
{
    if ( [self count] )
    {
        [self removeObjectAtIndex:0];
    }
    
    return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
    if ( [self count] > 0 )
    {
        if ( n >= [self count] )
        {
            [self removeAllObjects];
        }
        else
        {
            NSRange range;
            range.location = 0;
            range.length = n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
    if ( [self count] > n )
    {
        NSRange range;
        range.location = n;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
    if ( [self count] > n )
    {
        NSRange range;
        range.location = 0;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}


- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ( index >= self.count && index != 0)
    {
        return NO;
    }
    
    if (!anObject)
    {
        return NO;
    }
    
    [self insertObject:anObject atIndex:index];
    
    return YES;
}

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if ( index >= self.count )
    {
        return NO;
    }
    [self removeObjectAtIndex:index];
    return YES;
    
}
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ( index >= self.count )
    {
        return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
    return YES;
}


@end

