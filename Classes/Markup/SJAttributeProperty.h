//
//  SJAttributeProperty.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributeProperty : NSObject

/*!
 *  删除线
 *
 *  ex:
 *  make.strikethrough(NSUnderlineByWord |
 *                     NSUnderlinePatternSolid |
 *                     NSUnderlineStyleDouble, [UIColor blueColor])
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^strikethrough)(NSUnderlineStyle style, UIColor *color);

/*!
 *  下划线
 *
 *  ex:
 *  make.underline(NSUnderlineByWord |
 *                 NSUnderlinePatternSolid |
 *                 NSUnderlineStyleDouble, [UIColor blueColor])
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^underline)(NSUnderlineStyle style, UIColor *color);

/*!
 *  倾斜
 *
 *  建议值 -1 到 1 之间.
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^obliqueness)(float obliqueness);

/*!
 *  上下偏移
 *
 *  正值向上, 负数向下
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^nextOffset)(float offset);

/*!
 *  链接
 *
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^link)(void);

/*!
 *  扩大
 *
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^expansion)(float expansion);

/*!
 *  凸版
 *
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^letterpress)(void);

/*!
 *  border
 *
 *  如果大于0, 则显示的是空心字体
 *  如果小于0, 则显示实心字体(就像正常字体那样, 只不过是描边了)
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^stroke)(float border, UIColor *color);

/*!
 *  背景颜色
 *
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^backgroundColor)(UIColor *color);

/*!
 *  段落样式
 *
 **/
@property (nonatomic, copy, readonly) SJAttributeProperty *(^paragraphStyle)(NSParagraphStyle *style);

@end
