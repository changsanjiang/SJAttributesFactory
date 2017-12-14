//
//  SJLabel.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJLabel : UIView

/*!
 *  [font, textColor] if set nil, its will use the default values.
 **/
- (instancetype)initWithText:(NSString * __nullable)text
                        font:(UIFont * __nullable)font
                   textColor:(UIColor * __nullable)textColor
                 lineSpacing:(CGFloat)lineSpacing;

@property (nonatomic, strong, readwrite, nullable) NSString *text;

/*!
 *  default is systemFont(14).
 **/
@property (nonatomic, strong, readwrite) UIFont *font;

/*!
 *  default is black.
 **/
@property (nonatomic, strong, readwrite) UIColor *textColor;

/*!
 *  default is 3.
 **/
@property (nonatomic, assign, readwrite) CGFloat lineSpacing;

@end

NS_ASSUME_NONNULL_END
