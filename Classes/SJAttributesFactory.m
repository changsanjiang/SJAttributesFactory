//
//  SJAttributesFactory.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJAttributesFactory.h"
#import "SJAttributeWorker.h"
#import "SJAttributeMaker.h"

/*
 *  1. 派发任务
 *  2. 工厂接收
 *  3. 工厂根据任务, 分配工人完成任务
 */

@interface SJAttributesFactory ()

@end

@implementation SJAttributesFactory

+ (NSAttributedString *)alteringStr:(NSString *)str task:(void(^)(SJAttributeWorker *worker))task {
    NSAssert(str, @"param must not be empty!");
    SJAttributeWorker *worker = [SJAttributeWorker new];
    worker.insert(str, 0);
    task(worker);
    return [worker endTask];
}

+ (NSAttributedString *)alteringAttrStr:(NSAttributedString *)attrStr task:(void(^)(SJAttributeWorker *worker))task {
    NSAssert(attrStr, @"param must not be empty!");
    SJAttributeWorker *worker = [SJAttributeWorker new];
    worker.insert(attrStr, 0);
    task(worker);
    return [worker endTask];
}

+ (NSAttributedString *)producingWithImage:(UIImage *)image size:(CGSize)size task:(void(^)(SJAttributeWorker *worker))task {
    NSAssert(image, @"param must not be empty!");
    SJAttributeWorker *worker = [SJAttributeWorker new];
    worker.insert(image, 0, CGPointZero, size);
    task(worker);
    return [worker endTask];
}

+ (NSAttributedString *)producingWithTask:(void(^)(SJAttributeWorker *worker))task {
    return [self alteringStr:@"" task:task];
}

#pragma mark -
+ (NSAttributedString *)input:(id)input makeAttributes:(void(^)(SJAttributeMaker *make))block {
    if ( ![self isStrOrAttrStrOrImage:input] ) return nil;
    SJAttributeMaker *maker = [SJAttributeMaker new];
    block(maker);
    return [maker endTask];
}

+ (BOOL)isStrOrAttrStrOrImage:(id)input {
    return
    [input isKindOfClass:[NSString class]] ||
    [input isKindOfClass:[NSAttributedString class]] ||
    [input isKindOfClass:[UIImage class]];
}

@end
