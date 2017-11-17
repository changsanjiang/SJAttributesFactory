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

@interface SJAttributeMaker : NSObject

@property (nonatomic, copy, readonly) SJAttributeMaker *(^range)(NSUInteger location, NSUInteger length);

- (NSAttributedString *)endTask;

@property (nonatomic, strong) SJAttributeFont *font;
@property (nonatomic, strong) SJAttributeParagraph *paragraph;
@property (nonatomic, strong) SJAttributeEditContent *edit;
@property (nonatomic, strong) SJAttributeBounds *bounds;
@property (nonatomic, strong) SJAttributeProperty *property;

@end
