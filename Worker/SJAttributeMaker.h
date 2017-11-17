//
//  SJAttributeMaker.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJAttributeFont.h"
#import "SJAttributeParagraph.h"
#import "SJAttributeEditContent.h"
#import "SJAttributeBounds.h"
#import "SJAttributeProperty.h"
#import "SJAttributeRegularExpression.h"

@interface SJAttributeMaker : NSObject

@property (nonatomic, copy, readonly) SJAttributeMaker *(^range)(NSUInteger location, NSUInteger length, void(^)(SJAttributeMaker *range));

@property (nonatomic, strong, readonly) SJAttributeFont *font;
@property (nonatomic, strong, readonly) SJAttributeParagraph *paragraph;
@property (nonatomic, strong, readonly) SJAttributeEditContent *edit;
@property (nonatomic, strong, readonly) SJAttributeBounds *bounds;
@property (nonatomic, strong, readonly) SJAttributeProperty *property;
@property (nonatomic, strong, readonly) SJAttributeRegularExpression *regexp;

- (NSAttributedString *)endTask;

@end
