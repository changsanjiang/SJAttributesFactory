//
//  SJUIKitTextMaker.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SJUIKitTextMaker.h"
#import "SJUTRegexHandler.h"
#import "SJUTRangeHandler.h"

NS_ASSUME_NONNULL_BEGIN
inline static BOOL _SJUTRangeContains(NSRange main, NSRange sub) {
    return (main.location <= sub.location) && (main.location + main.length >= sub.location + sub.length);
}

@interface SJUIKitTextMaker ()
@property (nonatomic, strong, readonly) NSMutableArray<SJUTAttributes *> *attrs;
@property (nonatomic, strong, readonly) NSMutableArray<SJUTAttributes *> *updates;
@property (nonatomic, strong, readonly) NSMutableArray<SJUTRegexHandler *> *regexs;
@property (nonatomic, strong, readonly) NSMutableArray<SJUTRangeHandler *> *ranges;
@end

@implementation SJUIKitTextMaker
@synthesize attrs = _attrs;
- (NSMutableArray<SJUTAttributes *> *)attrs {
    if ( !_attrs ) _attrs = [NSMutableArray array];
    return _attrs;
}
@synthesize updates = _updates;
- (NSMutableArray<SJUTAttributes *> *)updates {
    if ( !_updates ) _updates = [NSMutableArray array];
    return _updates;
}
@synthesize regexs = _regexs;
- (NSMutableArray<SJUTRegexHandler *> *)regexs {
    if ( !_regexs ) _regexs = [NSMutableArray array];
    return _regexs;
}
@synthesize ranges = _ranges;
- (NSMutableArray<SJUTRangeHandler *> *)ranges {
    if ( !_ranges ) _ranges = [NSMutableArray array];
    return _ranges;
}

- (id<SJUTAttributesProtocol>  _Nonnull (^)(NSString * _Nonnull))append {
    return ^id<SJUTAttributesProtocol>(NSString *str) {
        SJUTAttributes *attr = [SJUTAttributes new];
        attr.recorder->string = str;
        [self.attrs addObject:attr];
        return attr;
    };
}
- (id<SJUTAttributesProtocol>  _Nonnull (^)(NSRange))update {
    return ^id<SJUTAttributesProtocol>(NSRange range) {
        SJUTAttributes *attr = [SJUTAttributes new];
        attr.recorder->range = range;
        [self.updates addObject:attr];
        return attr;
    };
}
- (id<SJUTAttributesProtocol>  _Nonnull (^)(void (^ _Nonnull)(id<SJUTImageAttachment> _Nonnull)))appendImage {
    return ^id<SJUTAttributesProtocol>(void(^block)(id<SJUTImageAttachment> make)) {
        SJUTAttributes *attr = [SJUTAttributes new];
        SJUTImageAttachment *attachment = [SJUTImageAttachment new];
        attr.recorder->attachment = attachment;
        block(attachment);
        [self.attrs addObject:attr];
        return attr;
    };
}
- (id<SJUTAttributesProtocol>  _Nonnull (^)(NSAttributedString * _Nonnull))appendText {
    return ^id<SJUTAttributesProtocol>(NSAttributedString *attrStr) {
        SJUTAttributes *attr = [SJUTAttributes new];
        attr.recorder->attrStr = [attrStr mutableCopy];
        [self.attrs addObject:attr];
        return attr;
    };
}
- (id<SJUTRegexHandlerProtocol>  _Nonnull (^)(NSString * _Nonnull))regex {
    return ^id<SJUTRegexHandlerProtocol>(NSString *regex) {
        SJUTRegexHandler *handler = [[SJUTRegexHandler alloc] initWithRegex:regex];
        [self.regexs addObject:handler];
        return handler;
    };
}
- (id<SJUTRangeHandlerProtocol>  _Nonnull (^)(NSRange))range {
    return ^id<SJUTRangeHandlerProtocol>(NSRange range) {
        SJUTRangeHandler *handler = [[SJUTRangeHandler alloc] initWithRange:range];
        [self.ranges addObject:handler];
        return handler;
    };
}
- (NSMutableAttributedString *)install {
    // default values
    SJUTRecorder *recorder = self.recorder;
    if ( recorder->font == nil ) recorder->font = [UIFont systemFontOfSize:14];
    if ( recorder->textColor == nil ) recorder->textColor = [UIColor blackColor];

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    // - attrs -
    if ( _attrs ) {
        for ( SJUTAttributes *attr in _attrs ) {
            NSMutableAttributedString *_Nullable current = [self _convertUTAttributesToText:attr];
            if ( current != nil ) {
                [result appendAttributedString:current];
            }
        }
        _attrs = nil;
    }
    [self _executeUpdateHandlersIfNeeded:result];
    [self _executeRangeHandlersIfNeeded:result];
    [self _executeUpdateHandlersIfNeeded:result];
    [self _executeRegexHandlersIfNeeded:result];
    [self _executeUpdateHandlersIfNeeded:result];
    return result;
}

- (NSMutableAttributedString *_Nullable)_convertUTAttributesToText:(SJUTAttributes *)attr {
    SJUTRecorder *recorder = attr.recorder;
    NSMutableAttributedString *_Nullable current = nil;
    if      ( recorder->string != nil ) {
        current = [[NSMutableAttributedString alloc] initWithString:recorder->string];
    }
    else if ( recorder->attachment != nil ) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = recorder->attachment.image;
        attachment.bounds = recorder->attachment.bounds;
        current = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;
    }
    
    if      ( current != nil ) {
        [self _setRecorderCommonValuesIfNeeded:recorder];
        [current addAttributes:[self convertRecorderToUIKitAttributes:recorder] range:NSMakeRange(0, current.length)];
    }
    else if ( recorder->attrStr != nil ) {
        current = recorder->attrStr;
        [current addAttributes:[self convertRecorderToUIKitAttributes:recorder] range:NSMakeRange(0, current.length)];
    }
    
    return current;
}

- (void)_executeRangeHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _ranges ) {
        for ( SJUTRangeHandler *handler in _ranges ) {
            SJUTRangeRecorder *recorder = handler.recorder;
            if ( recorder.range.length < 1 )
                continue;
            if ( recorder.attrOfReplaceWithString == nil && recorder.replaceWithText == nil && recorder.update == nil )
                continue;
            
            NSMutableAttributedString *_Nullable current = nil;
            if      ( recorder.attrOfReplaceWithString != nil ) {
                SJUTAttributes *attr = (SJUTAttributes *)recorder.attrOfReplaceWithString;
                [self _setRecroderSubtextCommonValues:attr.recorder subtext:[result attributedSubstringFromRange:recorder.range]];
                current = [self _convertUTAttributesToText:attr];
                [result replaceCharactersInRange:recorder.range withAttributedString:current];
            }
            else if ( recorder.replaceWithText != nil ) {
                SJUIKitTextMaker *maker = [[SJUIKitTextMaker alloc] init];
                [self _setRecroderSubtextCommonValues:maker.recorder subtext:[result attributedSubstringFromRange:recorder.range]];
                [self _setRecorderCommonValuesIfNeeded:maker.recorder];
                recorder.replaceWithText(maker);
                current = maker.install;
                [result replaceCharactersInRange:recorder.range withAttributedString:current];
            }
            else if ( recorder.update != nil ) {
                SJUTAttributes *attr = [[SJUTAttributes alloc] init];
                attr.recorder->range = recorder.range;
                recorder.update(attr);
                [self.updates addObject:attr];
            }
        }
        _ranges = nil;
    }
}

- (void)_executeRegexHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _regexs ) {
        for ( SJUTRegexHandler *handler in _regexs ) {
            NSString *string = result.string;
            NSRange resultRange = NSMakeRange(0, result.length);
            SJUTRegexRecorder *recorder = handler.recorder;
            if ( recorder.regex.length < 1 )
                continue;
            if ( recorder.update == nil && recorder.attrOfReplaceWithString == nil && recorder.replaceWithText == nil && recorder.handler == nil )
                continue;
            
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:recorder.regex options:recorder.regularExpressionOptions error:nil];
            NSMutableArray<NSTextCheckingResult *> *results = [NSMutableArray new];
            [regular enumerateMatchesInString:string options:recorder.matchingOptions range:resultRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                if ( result ) [results addObject:result];
            }];
            
            [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange range = obj.range;
                if ( recorder.update != nil ) {
                    SJUTAttributes *attr = [[SJUTAttributes alloc] init];
                    attr.recorder->range = range;
                    recorder.update(attr);
                    [self.updates addObject:attr];
                }
                else if ( recorder.attrOfReplaceWithString != nil ) {
                    SJUTAttributes *attr = (SJUTAttributes *)recorder.attrOfReplaceWithString;
                    [self _setRecroderSubtextCommonValues:attr.recorder subtext:[result attributedSubstringFromRange:range]];
                    NSAttributedString *attrStr = [self _convertUTAttributesToText:attr];
                    [result replaceCharactersInRange:range withAttributedString:attrStr];
                }
                else if ( recorder.replaceWithText != nil ) {
                    SJUIKitTextMaker *maker = [[SJUIKitTextMaker alloc] init];
                    [self _setRecroderSubtextCommonValues:maker.recorder subtext:[result attributedSubstringFromRange:range]];
                    [self _setRecorderCommonValuesIfNeeded:maker.recorder];
                    recorder.replaceWithText(maker);
                    NSAttributedString *attr = maker.install;
                    [result replaceCharactersInRange:range withAttributedString:attr];
                }
                else if ( recorder.handler != nil ) {
                    recorder.handler(result, obj);
                }
            }];
        }
        _regexs = nil;
    }
}

- (void)_executeUpdateHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _updates ) {
        NSRange resultRange = NSMakeRange(0, result.length);
        for ( SJUTAttributes *attr in _updates ) {
            SJUTRecorder *recorder = attr.recorder;
            NSRange range = recorder->range;
            if ( range.length == 0 ) continue;
            if ( _SJUTRangeContains(resultRange, range) ) {
                [self _setRecorderCommonValuesIfNeeded:recorder];
                [result addAttributes:[self convertRecorderToUIKitAttributes:recorder] range:recorder->range];
            }
        }
        _updates = nil;
    }
}

- (void)_setRecroderSubtextCommonValues:(SJUTRecorder *)recorder subtext:(NSAttributedString *)subtext {
    NSDictionary<NSAttributedStringKey, id> *dict = [subtext attributesAtIndex:0 effectiveRange:NULL];
    recorder->font = dict[NSFontAttributeName];
    recorder->textColor = dict[NSForegroundColorAttributeName];
}

- (void)_setRecorderCommonValuesIfNeeded:(SJUTRecorder *)recorder {
    SJUTRecorder *common = self.recorder;
#define SJUTSetRecorderCommonValueIfNeeded(__var__) if ( recorder->__var__ == nil ) recorder->__var__ = common->__var__;
    SJUTSetRecorderCommonValueIfNeeded(font);
    SJUTSetRecorderCommonValueIfNeeded(textColor);
    SJUTSetRecorderCommonValueIfNeeded(backgroundColor);
    
    SJUTSetRecorderCommonValueIfNeeded(alignment);
    SJUTSetRecorderCommonValueIfNeeded(lineSpacing);
    SJUTSetRecorderCommonValueIfNeeded(lineBreakMode);
    SJUTSetRecorderCommonValueIfNeeded(style);
    
    SJUTSetRecorderCommonValueIfNeeded(kern);
    SJUTSetRecorderCommonValueIfNeeded(stroke);
    SJUTSetRecorderCommonValueIfNeeded(shadow);
    SJUTSetRecorderCommonValueIfNeeded(underLine);
    SJUTSetRecorderCommonValueIfNeeded(strikethrough);
    SJUTSetRecorderCommonValueIfNeeded(baseLineOffset);
}

- (NSDictionary *)convertRecorderToUIKitAttributes:(SJUTRecorder *)recorder {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = recorder->font;
    attrs[NSForegroundColorAttributeName] = recorder->textColor;
    if ( recorder->backgroundColor != nil ) attrs[NSBackgroundColorAttributeName] = recorder->backgroundColor;
    attrs[NSParagraphStyleAttributeName] = [recorder paragraphStyle];
    if ( recorder->kern != nil ) attrs[NSKernAttributeName] = recorder->kern;
    SJUTStroke *_Nullable stroke = recorder->stroke;
    if ( stroke != nil ) {
        attrs[NSStrokeColorAttributeName] = stroke.color;
        attrs[NSStrokeWidthAttributeName] = @(stroke.width);
    }
    if ( recorder->shadow != nil ) attrs[NSShadowAttributeName] = recorder->shadow;
    SJUTDecoration *_Nullable underLine = recorder->underLine;
    if ( underLine != nil ) {
        attrs[NSUnderlineStyleAttributeName] = @(underLine.style);
        attrs[NSUnderlineColorAttributeName] = underLine.color;
    }
    SJUTDecoration *_Nullable strikethrough = recorder->strikethrough;
    if ( strikethrough != nil ) {
        attrs[NSUnderlineStyleAttributeName] = @(strikethrough.style);
        attrs[NSUnderlineColorAttributeName] = strikethrough.color;
    }
    if ( recorder->baseLineOffset != nil ) attrs[NSBaselineOffsetAttributeName] = recorder->baseLineOffset;
    return attrs;
}
@end
NS_ASSUME_NONNULL_END
