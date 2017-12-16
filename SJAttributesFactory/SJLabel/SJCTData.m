//
//  SJCTData.m
//  Test
//
//  Created by BlueDancer on 2017/12/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJCTData.h"

@implementation SJCTData

- (void)setFrameRef:(CTFrameRef)frameRef {
    if ( _frameRef != frameRef ) {
        if ( _frameRef ) CFRelease(_frameRef);
    }
    if ( frameRef ) CFRetain(_frameRef = frameRef);
}

- (void)dealloc {
    if ( _frameRef ) CFRelease(_frameRef);
}

- (id)copyWithZone:(NSZone *)zone {
    SJCTData *data = [SJCTData new];
    data.frameRef = self.frameRef;
    data.height = self.height;
    data.imageDataArray = self.imageDataArray;
    data.linkDataArray = self.linkDataArray;
    return data;
}

- (void)testWithContext:(CGContextRef)context {
//    CFArrayRef linesArr = CTFrameGetLines(_frameRef);
//    CFIndex lineNum = CFArrayGetCount(linesArr);
//
//    CGPoint origins[lineNum] = CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), <#CGPoint * _Nonnull origins#>)
//    for ( int i = 0 ; i < lineNum ; i ++ ) {
//
//    }
}

- (void)drawingWithContext:(CGContextRef)context {
    if ( 0 == _config.numberOfLines ) {
        CTFrameDraw(_frameRef, context);
        return;
    }
    
    NSUInteger numberOfLines = _config.numberOfLines;
    CTFrameRef frameRef = _frameRef;
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    
    NSAttributedString *attrStr = _attrStr;
    for ( CFIndex lineIndex = 0 ; lineIndex < numberOfLines ; lineIndex ++ ) {
        // 获取每一行的起始位置
        CGPoint lineOrigin = lineOrigins[lineIndex];
        // 设置绘制的起始位
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        
        CTLineRef nextLine = CFArrayGetValueAtIndex(lines, lineIndex);
        if ( lineIndex < numberOfLines - 1 ) {
            CTLineDraw(nextLine, context);
        }
        else {
            CFRange lastLineRange = CTLineGetStringRange(nextLine);
            if ( lastLineRange.location + lastLineRange.length < attrStr.length ) {
                
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                
                NSDictionary *lastAttributes = [attrStr attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
                NSAttributedString *ellipsisAttrStr = [[NSAttributedString alloc] initWithString:@"..." attributes:lastAttributes];
                CTLineRef ellipsisLineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)ellipsisAttrStr);
                
                NSMutableAttributedString *lastLineAttrStr =
                [[attrStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                
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
                CFRelease(truncationLine);
                CFRelease(ellipsisLineRef);
                
                CTLineDraw(truncatedLine, context);
                CFRelease(truncatedLine);
                
                
                
                
            }
        }
    }
}

@end
