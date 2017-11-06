//
//  SJAttributesFactory.h
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//
//  Attributes => http://www.jianshu.com/p/ebbcfc24f9cb

#import <UIKit/UIKit.h>

@interface SJAttributesFactory : NSObject

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *alter))block;

#pragma mark - All
@property (nonatomic, copy, readonly) SJAttributesFactory *(^font)(UIFont *font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^fontColor)(UIColor *fontColor);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^backgroundColor)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^lineSpacing)(float spacing);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterSpacing)(float spacing);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^alignment)(NSTextAlignment alignment);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^underline)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^strikethrough)(UIColor *color);

/// border 如果大于0, 则显示的是空心字体. 如果小于0, 则显示实心字体(就像正常字体那样, 只不过是描边了).
@property (nonatomic, copy, readonly) SJAttributesFactory *(^stroke)(float border, UIColor *color);

/// 凸版
@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterpress)(void);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphStyle)(NSParagraphStyle *style);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^insertImage)(UIImage *image, CGSize size, NSInteger index);

#pragma mark - Range
/// must set it up
@property (nonatomic, copy, readonly) void(^range)(NSRange range);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFont)(UIFont *font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFontColor)(UIColor *fontColor);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextBackgroundColor)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterSpacing)(float spacing);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextUnderline)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStrikethough)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStroke)(float border, UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterpress)(void);

@end

