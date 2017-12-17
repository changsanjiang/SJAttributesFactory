//
//  SJCTData.m
//  Test
//
//  Created by BlueDancer on 2017/12/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJCTData.h"

@interface SJLineModel : NSObject

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CTLineRef line;
@property (nonatomic, assign) CGFloat height;
@end

@implementation SJLineModel

- (void)setLine:(CTLineRef)line {
    if ( line != _line ) {
        if ( _line ) CFRetain(_line);
        _line = nil;
    }
    if ( line ) CFRetain(_line = line);
}

- (void)dealloc {
    if ( _line ) {
        CFRelease(_line);
        _line = nil;
    }
}
@end


@interface SJCTData ()

@property (nonatomic, strong) NSMutableArray<SJLineModel *> *needsDrawLinesM;

@end

@implementation SJCTData

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _needsDrawLinesM = [NSMutableArray array];
    return self;
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    if ( _frameRef != frameRef ) {
        if ( _frameRef ) CFRelease(_frameRef);
        _frameRef = nil;
    }
    if ( frameRef ) CFRetain(_frameRef = frameRef);
}

- (void)dealloc {
    if ( _frameRef ) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    SJCTData *data = [SJCTData new];
    data.frameRef = self.frameRef;
    data.height = self.height;
    data.imageDataArray = self.imageDataArray;
    data.linkDataArray = self.linkDataArray;
    return data;
}

- (void)needsDrawing {
    [_needsDrawLinesM removeAllObjects];
    NSUInteger numberOfLines = _config.numberOfLines;
    CTFrameRef frameRef = _frameRef;
    CFArrayRef linesArr = CTFrameGetLines(frameRef);
    NSUInteger lines = CFArrayGetCount(linesArr);
    if ( numberOfLines > lines || 0 == numberOfLines ) numberOfLines = lines;
    CGPoint baseLineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, numberOfLines), baseLineOrigins);
    
    for ( CFIndex lineIndex = 0 ; lineIndex < numberOfLines ; lineIndex ++ ) {
        // 获取每一行的起始位置
        CGPoint lineOrigin = baseLineOrigins[lineIndex];
        CTLineRef nextLine = CFArrayGetValueAtIndex(linesArr, lineIndex);
        CGFloat ascent = 0;
        CGFloat descent = 0;
        
        CTLineGetTypographicBounds(nextLine, &ascent, &descent, NULL);
        SJLineModel *recordLine = [SJLineModel new];
        recordLine.origin = lineOrigin;
        recordLine.line = nextLine;
        recordLine.height = ascent + descent;
        
        [_needsDrawLinesM addObject:recordLine];
    }
    
    if ( 0 != _config.numberOfLines && _config.numberOfLines < lines ) {
        NSUInteger lastLineIndex = _config.numberOfLines - 1;
        CFRange lastLineRange = CTLineGetStringRange(CFArrayGetValueAtIndex(linesArr, lastLineIndex));
        
        CTLineTruncationType truncationType = kCTLineTruncationEnd;
        NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
        
        NSDictionary *lastAttributes = [_attrStr attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
        NSAttributedString *ellipsisAttrStr = [[NSAttributedString alloc] initWithString:@"..." attributes:lastAttributes];
        CTLineRef ellipsisLineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)ellipsisAttrStr);
        
        NSMutableAttributedString *lastLineAttrStr =
        [[_attrStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
        
        if (lastLineRange.length > 0) {
            [lastLineAttrStr deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
        }
        [lastLineAttrStr appendAttributedString:ellipsisAttrStr];
        
        
        CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)lastLineAttrStr);
        CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine,
                                                            _config.maxWidth,
                                                            truncationType,
                                                            ellipsisLineRef);
        if ( !truncatedLine ) {
            // If the line is not as wide as the truncationToken, truncatedLine is NULL
            truncatedLine = CFRetain(ellipsisLineRef);
        }
    
        SJLineModel *recordLine = _needsDrawLinesM.lastObject;
        recordLine.line = truncatedLine;
        
        CFRelease(truncationLine);
        CFRelease(ellipsisLineRef);
        CFRelease(truncatedLine);
        
        _height_t = 0;
        __block CGFloat height = 0;
        [_needsDrawLinesM enumerateObjectsUsingBlock:^(SJLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            height += obj.height + _config.lineSpacing;
        }];
        _height_t = ceil(height);
    }
    else {
        _height_t = _height;
    }
}

- (void)drawingWithContext:(CGContextRef)context {
    [_needsDrawLinesM enumerateObjectsUsingBlock:^(SJLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextSetTextPosition(context, obj.origin.x, obj.origin.y - (_height - _height_t));
        CTLineDraw(obj.line, context);
    }];
    
    for ( SJCTImageData *imageData in _imageDataArray ) {
        UIImage *image = imageData.imageAttachment.image;
        CGRect position = imageData.imagePosition;
        position.origin.y -= ( _height - _height_t );
        if ( image ) { CGContextDrawImage(context, position, image.CGImage);}
    }
}
@end
