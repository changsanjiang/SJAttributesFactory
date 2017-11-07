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

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *worker))block;

#pragma mark - All
/// 整体字体
@property (nonatomic, copy, readonly) SJAttributesFactory *(^font)(UIFont *font);
/// 整体字体颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^fontColor)(UIColor *fontColor);
/// 整体背景颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^backgroundColor)(UIColor *color);
/// 整体每行间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^lineSpacing)(float spacing);
/// 整体字间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterSpacing)(float spacing);
/// 整体对齐方式
@property (nonatomic, copy, readonly) SJAttributesFactory *(^alignment)(NSTextAlignment alignment);
/// 整体下划线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^underline)(UIColor *color);
/// 整体删除线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^strikethrough)(UIColor *color);
/// border 如果大于0, 则显示的是空心字体. 如果小于0, 则显示实心字体(就像正常字体那样, 只不过是描边了).
@property (nonatomic, copy, readonly) SJAttributesFactory *(^stroke)(float border, UIColor *color);
/// 整体凸版
@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterpress)(void);
/// 整体段落样式
@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphStyle)(NSParagraphStyle *style);

#pragma mark - Range
/// must set it up. 如果只修改一部分, 最后必须设置他.
@property (nonatomic, copy, readonly) void(^range)(NSRange range);
/// 指定范围内的字体
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFont)(UIFont *font);
/// 指定范围内的字体颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFontColor)(UIColor *fontColor);
/// 指定范围内的背景颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextBackgroundColor)(UIColor *color);
/// 指定范围内的字间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterSpacing)(float spacing);
/// 指定范围内的下滑线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextUnderline)(UIColor *color);
/// 指定范围内的删除线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStrikethough)(UIColor *color);
/// 指定范围内的填充. 效果同 storke.
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStroke)(float border, UIColor *color);
/// 指定范围内的凸版
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterpress)(void);

#pragma mark - Insert
/// 指定位置插入图片
@property (nonatomic, copy, readonly) SJAttributesFactory *(^insertImage)(UIImage *image, CGSize size, NSInteger index);
@end

