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

@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphStyle)(NSParagraphStyle *style);

#pragma mark - Range
@property (nonatomic, copy, readonly) void(^range)(NSRange range);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFont)(UIFont *font);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFontColor)(UIColor *fontColor);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextBackgroundColor)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterSpacing)(float spacing);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextUnderline)(UIColor *color);

@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStrikethough)(UIColor *color);

@end

