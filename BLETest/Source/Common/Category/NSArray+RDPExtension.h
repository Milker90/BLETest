//
//  NSArray+RDPExtension.h
//  R360DP
//
//  Created by LiuDequan on 15/5/13.
//  Copyright (c) 2015年 liudequan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RDPExtension)
//取头部count个元素
- (NSArray *)head:(NSUInteger)count;
//取尾部count个元素
- (NSArray *)tail:(NSUInteger)count;

//加了安全保护，如果index大于总数会返回nil
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 *  @param index 元素下标
 *  @return 返回安全的NSString类型
 */
- (NSString *)strAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的int类型
 */
- (int)intAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的BOOL类型
 */
- (BOOL)boolAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的long类型
 */
- (long)longAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的long long类型
 */
- (long long)llongAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的double类型
 */
- (double)doubleAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的float类型
 */
- (float)floatAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的NSNumber类型
 */
- (NSNumber *)numAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的NSArray类型
 */
- (NSArray *)arrAt:(NSUInteger)index;
/**
 *  @param index 元素下标
 *  @return 返回安全的NSDictionary类型
 */
- (NSDictionary *)dicAt:(NSUInteger)index;

/**
 *  @return 返回数组最后下标
 */
- (NSUInteger)lastIndex;

//将array变成data
-(NSData*)data;
@end

#pragma mark -

@interface NSMutableArray (RDPExtension)

//在头部插入一个obj（可作为堆栈使用）
- (NSMutableArray *)pushHead:(NSObject *)obj;
//在头部插入一个arry（可作为堆栈使用）
- (NSMutableArray *)pushHeadN:(NSArray *)all;
//在尾部插入一个obj（可作为堆栈使用）
- (NSMutableArray *)pushTail:(NSObject *)obj;
//在尾部插入一个arry（可作为堆栈使用）
- (NSMutableArray *)pushTailN:(NSArray *)all;
//移除尾部一个obj（可作为堆栈使用）
- (NSMutableArray *)popTail;
//移除尾部N个obj（可作为堆栈使用）
- (NSMutableArray *)popTailN:(NSUInteger)n;
//移除头部一个obj（可作为堆栈使用）
- (NSMutableArray *)popHead;
//移除头部N个obj（可作为堆栈使用）
- (NSMutableArray *)popHeadN:(NSUInteger)n;
//仅保留头部n个数据
- (NSMutableArray *)keepHead:(NSUInteger)n;
//仅保留尾部n个数据
- (NSMutableArray *)keepTail:(NSUInteger)n;

//安全add函数
- (void)safeAddObject:(id)anObject;
//安全插入函数
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
//安全移除函数
-(bool)safeRemoveObjectAtIndex:(NSUInteger)index;
//安全替换函数
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
