//
//  SJAttributesFactory.h
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributesFactory : NSObject

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *alter))block;

#pragma mark - All

/**
 修改整体的字体
 */
@property (nonatomic, copy, readonly) SJAttributesFactory *(^font)(UIFont *font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^fontColor)(UIColor *fontColor);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^lineSpacing)(float lineSpacing);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^alignment)(NSTextAlignment alignment);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphStyle)(NSParagraphStyle *style);

#pragma mark - Range
@property (nonatomic, copy, readonly) void(^range)(NSRange range);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFont)(float font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextBoldFont)(float font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFontColor)(UIColor *fontColor);

@end

