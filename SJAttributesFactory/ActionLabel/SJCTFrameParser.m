//
//  SJCTFrameParser.m
//  Test
//
//  Created by BlueDancer on 2017/12/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJCTFrameParser.h"
#import "SJCTData.h"
#import "SJCTFrameParserConfig.h"
#import <CoreText/CoreText.h>

@implementation SJCTFrameParser

+ (NSDictionary *)attributesWithConfig:(SJCTFrameParserConfig *)config { // 是否可以直接将 paragraph 转换.
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)config.font.fontName, [SJCTFrameParserConfig fontSize:config.font], NULL);
    CGFloat lineSpacing = config.lineSpacing;
    const size_t _kNumberOfSettings = 3;
    CTParagraphStyleSetting paragraphStyleSettings[_kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(paragraphStyleSettings, _kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (__bridge id _Nullable)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)paragraphRef;
    
    CFRelease(paragraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (SJCTData *)parserContent:(NSString *)content config:(SJCTFrameParserConfig *)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    return [self parserAttributedContent:attrStr config:config];
}

+ (SJCTData *)parserAttributedContent:(NSAttributedString *)content config:(SJCTFrameParserConfig *)config {
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    CGFloat contentHeight = [self contentHeightWithFramesetter:setter maxWidth:config.maxWidth];
    CGRect rect = CGRectMake(0, 0, config.maxWidth, contentHeight);
    CGMutablePathRef pathM = CGPathCreateMutable();
    CGPathAddRect(pathM, NULL, rect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), pathM, NULL);
    SJCTData *ctdata = [SJCTData new];
    ctdata.frameRef = frameRef;
    ctdata.height = contentHeight;
    
    CFRelease(frameRef);
    CFRelease(pathM);
    CFRelease(setter);
    return ctdata;
}


+ (CGFloat)contentHeightWithFramesetter:(CTFramesetterRef)framesetter maxWidth:(CGFloat)maxWidth {
    CGSize constraints = CGSizeMake(maxWidth, CGFLOAT_MAX);
    CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, constraints, NULL);
    return contentSize.height;
}

@end
