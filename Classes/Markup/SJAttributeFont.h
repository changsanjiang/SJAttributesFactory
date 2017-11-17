//
//  SJAttributeFont.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributeFont : NSObject

/// 字体
@property (nonatomic, copy, readonly) SJAttributeFont *(^face)(UIFont *font);

/// 字体间隔
@property (nonatomic, copy, readonly) SJAttributeFont *(^letterSpace)(CGFloat letterSpace);

/// 字体颜色
@property (nonatomic, copy, readonly) SJAttributeFont *(^color)(UIColor *color);

/// 阴影偏移
@property (nonatomic, copy, readonly) SJAttributeFont *(^shadowOffset)(CGSize shadowOffset);

/// 阴影模糊半径
@property (nonatomic, copy, readonly) SJAttributeFont *(^shadowBlurRadius)(CGFloat shadowBlurRadius);

/// 阴影颜色
@property (nonatomic, copy, readonly) SJAttributeFont *(^shadowColor)(UIColor *shadowColor);

@end
