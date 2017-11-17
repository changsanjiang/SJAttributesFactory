//
//  SJAttributeMaker.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJAttributeMaker.h"

@implementation SJAttributeMaker

- (SJAttributeMaker *(^)(NSUInteger, NSUInteger))range {
    return ^ SJAttributeMaker *(NSUInteger location, NSUInteger length) {
        
        return self;
    };
}

- (NSAttributedString *)endTask {
    return nil;
}

@end
