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

@property (nonatomic) BOOL needsDrawing;

@property (nonatomic, strong) SJCTData *drawData;

@end

@implementation SJLabel

@synthesize text = _text;
@synthesize config = _config;

- (instancetype)init {
    return [self initWithText:nil font:nil textColor:nil lineSpacing:8];
}

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                 lineSpacing:(CGFloat)lineSpacing {
    self = [super initWithFrame:CGRectZero];
    if ( !self ) return nil;
    _config = [self __defaultConfig];
    self.text = text;
    self.font = font;
    self.textColor = textColor;
    self.lineSpacing = lineSpacing;
    [self _setupGestures];
    self.userInteractionEnabled = NO;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _config.maxWidth = self.frame.size.width;
    [self _considerUpdating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, ceil(_drawData.height_t));
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ( !_needsDrawing ) return;
    NSLog(@"%zd - %s - %@", __LINE__, __func__, NSStringFromCGSize(rect.size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, _drawData.height_t);
    CGContextScaleCTM(context, 1.0, -1.0);
    [_drawData drawingWithContext:context];
    _needsDrawing = NO;
}

- (void)_setupGestures {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    [_drawData touchIndexWithPoint:point];
}


#pragma mark - Private

- (void)_considerUpdating {
    if ( 0 == _config.maxWidth ) return;
    
    if ( 0 == _text.length && 0 == _attributedText.length ) {
        _drawData = nil;
    }
    else {
        _needsDrawing = YES;
        if ( _text ) _drawData = [SJCTFrameParser parserContent:_text config:_config];
        if ( _attributedText ) _drawData = [SJCTFrameParser parserAttributedStr:_attributedText config:_config];
        [_drawData needsDrawing];
        [self invalidateIntrinsicContentSize];
    }
    [self.layer setNeedsDisplay];
}

#pragma mark - Property

- (void)setText:(NSString *)text {
    _text = text.copy;
    _attributedText = nil;
    [self _considerUpdating];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText.copy;
    _text = nil;
    [self _considerUpdating];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if ( textAlignment == _config.textAlignment ) return;
    self.config.textAlignment = textAlignment;
    [self _considerUpdating];
}

- (NSTextAlignment)textAlignment {
    return self.config.textAlignment;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    if ( numberOfLines == _config.numberOfLines ) return;
    self.config.numberOfLines = numberOfLines;
    [self _considerUpdating];
}

- (NSUInteger)numberOfLines {
    return self.config.numberOfLines;
}

- (void)setFont:(UIFont *)font {
    if ( !font || font == _config.font || [font isEqual:_config.font] ) return;
    self.config.font = font;
    [self _considerUpdating];
}

- (UIFont *)font {
    return self.config.font;
}

- (void)setTextColor:(UIColor *)textColor {
    if ( !textColor || textColor == _config.textColor ) return;
    self.config.textColor = textColor;
    [self _considerUpdating];
}

- (UIColor *)textColor {
    return self.config.textColor;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if ( lineSpacing == _config.lineSpacing ) return;
    self.config.lineSpacing = lineSpacing;
    [self _considerUpdating];
}

- (CGFloat)lineSpacing {
    return self.config.lineSpacing;
}

- (CGFloat)height {
    return ceil(_drawData.height_t);
}

- (SJCTFrameParserConfig *)__defaultConfig {
    SJCTFrameParserConfig *defaultConfig = [SJCTFrameParserConfig new];
    defaultConfig.font = [UIFont systemFontOfSize:14];
    defaultConfig.textColor = [UIColor blackColor];
    defaultConfig.lineSpacing = 0;
    defaultConfig.textAlignment = NSTextAlignmentLeft;
    defaultConfig.numberOfLines = 1;
    defaultConfig.lineBreakMode = NSLineBreakByTruncatingTail;
    return defaultConfig;
}

@end
