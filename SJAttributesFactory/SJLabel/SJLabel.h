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
@property (nonatomic, strong, readwrite, null_resettable) UIFont *font;

/*!
 *  default is black.
 **/
@property (nonatomic, strong, readwrite, null_resettable) UIColor *textColor;

/*!
 *  default is 8.
 **/
@property (nonatomic, assign, readwrite) CGFloat lineSpacing;

@property (nonatomic, assign, readonly) CGFloat height;

@end

NS_ASSUME_NONNULL_END
