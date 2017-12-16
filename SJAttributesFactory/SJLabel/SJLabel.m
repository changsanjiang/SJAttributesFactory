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
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ( !_needsDrawing ) return;
    NSLog(@"%zd - %s", __LINE__, __func__);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
//    CFArrayRef lines = CTFrameGetLines(_drawData.frameRef);
////    CTLineRef fristLine = CFArrayGetValueAtIndex(lines, 0);
////    CTLineDraw(fristLine, context);
//    CTLineRef secondLine = CFArrayGetValueAtIndex(lines, 1);
//    CTLineDraw(secondLine, context);
    
    if ( 0 == _config.numberOfLines ) {
        CTFrameDraw(_drawData.frameRef, context);
    }
    else {
        CTFrameRef frameRef = _drawData.frameRef;
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CGPoint lineOrigins[_config.numberOfLines];
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, _config.numberOfLines), lineOrigins);
        NSAttributedString *attrStr = _drawData.attrStr;
        for ( CFIndex lineIndex = 0 ; lineIndex < _config.numberOfLines ; lineIndex ++ ) {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            BOOL shouldDrawLine = YES;
            if ( lineIndex == _config.numberOfLines - 1 ) {
                CFRange lastLineRange = CTLineGetStringRange(line);
                if ( lastLineRange.location + lastLineRange.length < attrStr.length ) {
                    CTLineTruncationType truncationType = kCTLineTruncationEnd;
                    // 加省略号的位置
                    NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;

                    // 获取省略号位置的字符串属性
                    NSDictionary *tokenAttributes = [attrStr attributesAtIndex:truncationAttributePosition
                                                                         effectiveRange:NULL];
                    // 初始化省略号的属性字符串
                    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:@"..."
                                                                                      attributes:tokenAttributes];
                    // 创建一行
                    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                    NSMutableAttributedString *truncationString = [[attrStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];

                    if (lastLineRange.length > 0)
                    {
                        // Remove last token
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                    }
                    [truncationString appendAttributedString:tokenString];

                    // 创建省略号的行
                    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
                    // 在省略号行的末尾加上省略号
                    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                    if ( !truncatedLine )
                    {
                        // If the line is not as wide as the truncationToken, truncatedLine is NULL
                        truncatedLine = CFRetain(truncationToken);
                    }
                    CFRelease(truncationLine);
                    CFRelease(truncationToken);

                    CTLineDraw(truncatedLine, context);
                    CFRelease(truncatedLine);

                    shouldDrawLine = NO;
                }
            }
            
            if(shouldDrawLine)
            {
                CTLineDraw(line, context);
            }
        }
    }
//
//    for ( SJCTImageData *imageData in _drawData.imageDataArray ) {
//        UIImage *image = imageData.imageAttachment.image;
//        if ( image ) { CGContextDrawImage(context, imageData.imagePosition, image.CGImage);}
//    }
    _needsDrawing = NO;
}

#pragma mark - Private

- (void)_considerUpdating {
    if ( 0 == _text.length ) {
        _drawData = nil;
    }
    else {
        _needsDrawing = YES;
        _drawData = [SJCTFrameParser parserContent:_text config:_config];
    }
    [self.layer setNeedsDisplay];
}

#pragma mark - Property

- (void)setText:(NSString *)text {
    if ( [text isEqualToString:_text] ) return;
    _text = text;
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
    return ceil(self.drawData.height);
}

- (SJCTFrameParserConfig *)__defaultConfig {
    SJCTFrameParserConfig *defaultConfig = [SJCTFrameParserConfig new];
    defaultConfig.font = [UIFont systemFontOfSize:14];
    defaultConfig.textColor = [UIColor blackColor];
    defaultConfig.lineSpacing = 8;
    defaultConfig.maxWidth = [UIScreen mainScreen].bounds.size.width;
    defaultConfig.textAlignment = NSTextAlignmentLeft;
    defaultConfig.numberOfLines = 1;
    defaultConfig.lineBreakMode = NSLineBreakByTruncatingTail;
    return defaultConfig;
}

@end
