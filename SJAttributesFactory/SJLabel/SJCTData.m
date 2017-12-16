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
    if ( 0 == numberOfLines ) return;
    
    CTFrameRef frameRef = _frameRef;
    CFArrayRef linesArr = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for ( CFIndex lineIndex = 0 ; lineIndex < numberOfLines - 1 ; lineIndex ++ ) {
        // 获取每一行的起始位置
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef nextLine = CFArrayGetValueAtIndex(linesArr, lineIndex);
        
        SJLineModel *recordLine = [SJLineModel new];
        recordLine.origin = lineOrigin;
        recordLine.line = nextLine;
        
        [_needsDrawLinesM addObject:recordLine];
    }
    
    
//    NSUInteger lastLineIndex = numberOfLines - 1;
//    CGPoint lineOrigin = lineOrigins[lastLineIndex];
//
//    CTLineRef lastLine = CFArrayGetValueAtIndex(linesArr, lastLineIndex);
//    CFRange lastLineRange = CTLineGetStringRange(CFArrayGetValueAtIndex(linesArr, lastLineIndex));
//
//    CTLineTruncationType truncationType = kCTLineTruncationEnd;
//    NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
//
//    NSDictionary *lastAttributes = [_attrStr attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
//    NSAttributedString *ellipsisAttrStr = [[NSAttributedString alloc] initWithString:@"..." attributes:lastAttributes];
//    CTLineRef ellipsisLineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)ellipsisAttrStr);
//
//    NSMutableAttributedString *lastLineAttrStr =
//    [[_attrStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
//
//    if (lastLineRange.length > 0) {
//        [lastLineAttrStr deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
//    }
//    [lastLineAttrStr appendAttributedString:ellipsisAttrStr];
//
//
//    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)lastLineAttrStr);
//    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine,
//                                                        _config.maxWidth,
//                                                        truncationType,
//                                                        ellipsisLineRef);
//    if ( !truncatedLine ) {
//        // If the line is not as wide as the truncationToken, truncatedLine is NULL
//        truncatedLine = CFRetain(ellipsisLineRef);
//    }
//
//
//    CGFloat ascent = 0;
//    CGFloat descent = 0;
//    CTLineGetTypographicBounds(lastLine, &ascent, &descent, NULL);
//    _height = lineOrigin.y + ascent + descent + _config.lineSpacing;
//    SJLineModel *recordLine = [SJLineModel new];
//    recordLine.origin = lineOrigin;
//    recordLine.line = truncatedLine;
//    [_needsDrawLinesM addObject:recordLine];
//
//    CFRelease(truncationLine);
//    CFRelease(ellipsisLineRef);
//    CFRelease(truncatedLine);
}

- (void)drawingWithContext:(CGContextRef)context {
    [_needsDrawLinesM enumerateObjectsUsingBlock:^(SJLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextSetTextPosition(context, obj.origin.x, obj.origin.y);
        CTLineDraw(obj.line, context);
    }];
}

//- (void)drawingWithContext:(CGContextRef)context {
//    if ( 0 == _config.numberOfLines ) {
//        CTFrameDraw(_frameRef, context);
//        return;
//    }
//
//    NSUInteger numberOfLines = _config.numberOfLines;
//    CTFrameRef frameRef = _frameRef;
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    CGPoint lineOrigins[numberOfLines];
//    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
//
//    NSAttributedString *attrStr = _attrStr;
//    for ( CFIndex lineIndex = 0 ; lineIndex < numberOfLines ; lineIndex ++ ) {
//        // 获取每一行的起始位置
//        CGPoint lineOrigin = lineOrigins[lineIndex];
//        // 设置绘制的起始位
//        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
//
//        CTLineRef nextLine = CFArrayGetValueAtIndex(lines, lineIndex);
//        if ( lineIndex < numberOfLines - 1 ) {
//            CTLineDraw(nextLine, context);
//        }
//        else {
//            CFRange lastLineRange = CTLineGetStringRange(nextLine);
//            if ( lastLineRange.location + lastLineRange.length < attrStr.length ) {
//
//                CTLineTruncationType truncationType = kCTLineTruncationEnd;
//                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
//
//                NSDictionary *lastAttributes = [attrStr attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
//                NSAttributedString *ellipsisAttrStr = [[NSAttributedString alloc] initWithString:@"..." attributes:lastAttributes];
//                CTLineRef ellipsisLineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)ellipsisAttrStr);
//
//                NSMutableAttributedString *lastLineAttrStr =
//                [[attrStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
//
//                if (lastLineRange.length > 0) {
//                    [lastLineAttrStr deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
//                }
//                [lastLineAttrStr appendAttributedString:ellipsisAttrStr];
//
//
//                CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)lastLineAttrStr);
//                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine,
//                                                                    _config.maxWidth,
//                                                                    truncationType,
//                                                                    ellipsisLineRef);
//                if ( !truncatedLine ) {
//                    // If the line is not as wide as the truncationToken, truncatedLine is NULL
//                    truncatedLine = CFRetain(ellipsisLineRef);
//                }
//
//
//                CGFloat ascent = 0;
//                CGFloat descent = 0;
//                CTLineGetTypographicBounds(nextLine, &ascent, &descent, NULL);
//
//                _height = lineOrigin.y + ascent + descent + _config.lineSpacing;
//
//                CFRelease(truncationLine);
//                CFRelease(ellipsisLineRef);
//
//                CTLineDraw(truncatedLine, context);
//                CFRelease(truncatedLine);
//            }
//        }
//    }
//}

@end
