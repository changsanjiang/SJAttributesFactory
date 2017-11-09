//
//  SJAttributesFactory.h
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//
//
//  关于属性介绍请移步 => http://www.jianshu.com/p/ebbcfc24f9cb

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJAttributesFactory : NSObject

#pragma mark - Create
+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *worker))block;

+ (NSAttributedString *)alterAttrStr:(NSAttributedString *)attrStr block:(void(^)(SJAttributesFactory *worker))block;

+ (NSAttributedString *)alterWithImage:(UIImage *)image offset:(CGPoint)offset size:(CGSize)size block:(void(^)(SJAttributesFactory *worker))block;

+ (NSAttributedString *)alterWithBlock:(void(^)(SJAttributesFactory *worker))block;


#pragma mark - All
/*!
 *  Setting the whole may affect the local range properties,
 *  please set the whole first, and then set the local range properties.
 *
 *  设置整体可能会影响局部范围属性, 请先设置整体, 然后再设置局部范围属性.
 *  也可不设置整体, 只设置局部属性.
 **/
/// 整体 字体
@property (nonatomic, copy, readonly) SJAttributesFactory *(^font)(UIFont *font);
/// 整体 放大
@property (nonatomic, copy, readonly) SJAttributesFactory *(^expansion)(float expansion);
/// 整体 字体颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^fontColor)(UIColor *fontColor);
/// 整体 字体阴影
@property (nonatomic, copy, readonly) SJAttributesFactory *(^shadow)(NSShadow *shadow);
/// 整体 背景颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^backgroundColor)(UIColor *color);
/// 整体 每行间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^lineSpacing)(float spacing);
/// 整体 段后间隔(\n)
@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphSpacing)(float paragraphSpacing);
/// 整体 段前间隔(\n)
@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphSpacingBefore)(float paragraphSpacingBefore);
/// 首行头缩进
@property (nonatomic, copy, readonly) SJAttributesFactory *(^firstLineHeadIndent)(float padding);
/// 左缩进
@property (nonatomic, copy, readonly) SJAttributesFactory *(^headIndent)(float headIndent);
/// 右缩进(正值从左算起, 负值从右算起)
@property (nonatomic, copy, readonly) SJAttributesFactory *(^tailIndent)(float tailIndent);
/// 整体 字间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterSpacing)(float spacing);
/// 整体 对齐方式
@property (nonatomic, copy, readonly) SJAttributesFactory *(^alignment)(NSTextAlignment alignment);
/// line break mode
@property (nonatomic, copy, readonly) SJAttributesFactory *(^lineBreakMode)(NSLineBreakMode mode);

/*!
 *  整体 添加下划线
 *  ex:
 *  worker.underline(NSUnderlineByWord |
 *                   NSUnderlinePatternSolid |
 *                   NSUnderlineStyleDouble, [UIColor blueColor])
 **/
@property (nonatomic, copy, readonly) SJAttributesFactory *(^underline)(NSUnderlineStyle style, UIColor *color);
/*!
 *  整体 添加删除线
 *  ex:
 *  worker.strikethrough(NSUnderlineByWord |
 *                       NSUnderlinePatternSolid |
 *                       NSUnderlineStyleDouble, [UIColor blueColor])
 **/
@property (nonatomic, copy, readonly) SJAttributesFactory *(^strikethrough)(NSUnderlineStyle style, UIColor *color);
/// border 如果大于0, 则显示的是空心字体. 如果小于0, 则显示实心字体(就像正常字体那样, 只不过是描边了).
@property (nonatomic, copy, readonly) SJAttributesFactory *(^stroke)(float border, UIColor *color);
/// 整体 凸版
@property (nonatomic, copy, readonly) SJAttributesFactory *(^letterpress)(void);
/// 整体 段落样式
@property (nonatomic, copy, readonly) SJAttributesFactory *(^paragraphStyle)(NSParagraphStyle *style);
/// 整体 倾斜. 建议值 -1 到 1 之间.
@property (nonatomic, copy, readonly) SJAttributesFactory *(^obliqueness)(float obliqueness);


#pragma mark - Range
/// must set it up. 如果只修改一部分, 最后必须设置他. 这个很重要.
@property (nonatomic, copy, readonly) void(^range)(NSRange range);
/// 指定范围内的 字体
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFont)(UIFont *font);
/// 指定范围内的 字体放大
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextExpansion)(float nextExpansion);
/// 指定范围内的 字体颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextFontColor)(UIColor *fontColor);
/// 指定范围内的 阴影
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextShadow)(NSShadow *shadow);
/// 指定范围内的 背景颜色
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextBackgroundColor)(UIColor *color);
/// 指定范围内的 字间隔
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterSpacing)(float spacing);
/// 指定范围内的 下划线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextUnderline)(NSUnderlineStyle style, UIColor *color);
/// 指定范围内的 删除线
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStrikethough)(NSUnderlineStyle style, UIColor *color);
/// 指定范围内的 填充. 效果同 storke.
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextStroke)(float border, UIColor *color);
/// 指定范围内的 凸版
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLetterpress)(void);
/// 指定范围内为链接
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextLink)(void);
/// 指定范围内上下的偏移量. 正值向上, 负数向下.
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextOffset)(float offset);
/// 指定范围内倾斜. 建议值 -1 到 1 之间.
@property (nonatomic, copy, readonly) SJAttributesFactory *(^nextObliqueness)(float obliqueness);


#pragma mark - Insert
/*!
 *  Insert a image at the specified position.
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入图片.
 *  如果 index = -1, 将会插到文本最后
 **/
@property (nonatomic, copy, readonly) SJAttributesFactory *(^insertImage)(UIImage *image, CGPoint offset, CGSize size, NSInteger index);
/*!
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入文本.
 *  如果 index = -1, 将会插到文本最后.
 **/
@property (nonatomic, copy, readonly) SJAttributesFactory *(^insertAttr)(NSAttributedString *attr, NSInteger index);
/*!
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入文本.
 *  如果 index = -1, 将会插到文本最后
 **/
@property (nonatomic, copy, readonly) SJAttributesFactory *(^insertText)(NSString *text, NSInteger index);


#pragma mark - Remove
/// 指定范围 删除文本
@property (nonatomic, copy, readonly) SJAttributesFactory *(^removeText)(NSRange range);
/// 指定范围 删除属性
@property (nonatomic, copy, readonly) SJAttributesFactory *(^removeAttribute)(NSAttributedStringKey key, NSRange range);
/// 除字体大小, 清除文本其他属性
@property (nonatomic, copy, readonly) void (^clean)(void);


#pragma mark - Other
/// 获取当前文本的长度
@property (nonatomic, assign, readonly) NSInteger length;
/// 获取指定范围文本宽度. (必须设置过字体)
@property (nonatomic, copy, readonly) CGFloat(^width)(NSRange range);

@end

NS_ASSUME_NONNULL_END
