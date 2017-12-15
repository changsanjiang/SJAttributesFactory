//
//  SJLabel.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJLabel.h"
#import <CoreText/CoreText.h>
#import "SJCTData.h"
#import "SJCTFrameParser.h"
#import "SJCTFrameParserConfig.h"
#import "SJCTImageData.h"

@interface SJLabel ()

@property (nonatomic, strong, readonly) SJCTFrameParserConfig *config;
@property (nonatomic, strong, readwrite) SJCTData *data;

@end

@implementation SJLabel

@synthesize text = _text;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize lineSpacing = _lineSpacing;
@synthesize config = _config;

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                 lineSpacing:(CGFloat)lineSpacing {
    self = [super initWithFrame:CGRectZero];
    if ( !self ) return nil;
    self.text = text;
    self.font = font;
    self.textColor = textColor;
    self.lineSpacing = lineSpacing;
    return self;
}

- (void)setFont:(UIFont *)font {
    self.config.font = font;
}

- (UIFont *)font {
    return self.config.font;
}

- (void)setTextColor:(UIColor *)textColor {
    self.config.textColor = textColor;
}

- (UIColor *)textColor {
    return self.config.textColor;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    self.config.lineSpacing = lineSpacing;
}

- (CGFloat)lineSpacing {
    return self.config.lineSpacing;
}

- (CGFloat)height {
    return self.data.height;
}

- (SJCTFrameParserConfig *)config {
    if ( _config ) return _config;
    _config = [SJCTFrameParserConfig new];
    _config.font = [UIFont systemFontOfSize:14];
    _config.textColor = [UIColor blackColor];
    _config.lineSpacing = 8;
    _config.maxWidth = [UIScreen mainScreen].bounds.size.width;
    return _config;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    _data = [SJCTFrameParser parserContent:_text config:_config];
    if ( _data ) { CTFrameDraw(_data.frameRef, context);}
    for ( SJCTImageData *imageData in _data.imageDataArray ) {
        UIImage *image = imageData.imageAttachment.image;
        if ( image ) { CGContextDrawImage(context, imageData.imagePosition, image.CGImage);}
    }
}

@end
