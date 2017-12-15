//
//  SJLabel.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJLabel.h"

@interface SJLabel ()

@end

@implementation SJLabel

@synthesize text = _text;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize lineSpacing = _lineSpacing;

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                 lineSpacing:(CGFloat)lineSpacing {
    self = [super initWithFrame:CGRectZero];
    if ( !self ) return nil;
    _text = text;
    _font = font;
    _textColor = textColor;
    _lineSpacing = lineSpacing;
    return self;
}

- (UIFont *)font {
    if ( _font ) return _font;
    return [UIFont systemFontOfSize:14];
}

- (UIColor *)textColor {
    if ( _textColor ) return _textColor;
    return [UIColor blackColor];
}

- (CGFloat)lineSpacing {
    if ( 0 != _lineSpacing ) return _lineSpacing;
    return 3;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

@end
