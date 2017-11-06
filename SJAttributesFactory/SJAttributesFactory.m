//
//  SJAttributesFactory.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJAttributesFactory.h"

@interface SJAttributesFactory ()

@property (nonatomic, strong, readonly) NSMutableAttributedString *attrM;
@property (nonatomic, strong, readonly) NSMutableParagraphStyle *style;

@property (nonatomic, strong, readwrite) NSNumber *r_Font;
@property (nonatomic, strong, readwrite) NSNumber *r_Bold_Font;
@property (nonatomic, strong, readwrite) UIColor *r_FontColor;

@end

@implementation SJAttributesFactory

@synthesize attrM = _attrM;
@synthesize style = _style;

- (instancetype)initWithAttr:(NSMutableAttributedString *)attr {
    self = [super init];
    if ( !self ) return nil;
    _attrM = attr;
    return self;
}

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *alter))block {
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:str];
    if ( block ) block([[SJAttributesFactory alloc] initWithAttr:attrStrM]);
    return attrStrM;
}

#pragma mark -

- (SJAttributesFactory *(^)(float))font {
    return ^ SJAttributesFactory *(float font) {
        [_attrM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(float))boldFont {
    return ^ SJAttributesFactory *(float font) {
        [_attrM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))fontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        [_attrM addAttribute:NSForegroundColorAttributeName value:fontColor range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(float))lineSpacing {
    return ^ SJAttributesFactory *(float lineSpacing) {
        self.style.lineSpacing = lineSpacing;
        return self;
    };
}

- (SJAttributesFactory *(^)(NSTextAlignment))alignment {
    return ^ SJAttributesFactory *(NSTextAlignment alignment) {
        self.style.alignment = alignment;
        return self;
    };
}

- (SJAttributesFactory *(^)(NSParagraphStyle *))paragraphStyle {
    return ^ SJAttributesFactory *(NSParagraphStyle *style) {
        [_attrM addAttribute:NSParagraphStyleAttributeName value:style range:_rangeAll(_attrM)];
        return self;
    };
}

#pragma mark -

- (void (^)(NSRange))range {
    return ^(NSRange range) {
        if ( _r_Font ) [_attrM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[_r_Font floatValue]] range:range];
        if ( _r_Bold_Font ) [_attrM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[_r_Bold_Font floatValue]] range:range];
        if ( _r_FontColor ) [_attrM addAttribute:NSForegroundColorAttributeName value:_r_FontColor range:range];
        
        // clear
        _r_Font = nil;
        _r_Bold_Font = nil;
        _r_FontColor = nil;
    };
}

- (SJAttributesFactory *(^)(float))nextFont {
    return ^ SJAttributesFactory *(float font) {
        _r_Font = @(font);
        return self;
    };
}

- (SJAttributesFactory *(^)(float))nextBoldFont {
    return ^ SJAttributesFactory *(float font) {
        _r_Bold_Font = @(font);
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *color))nextFontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        _r_FontColor = fontColor;
        return self;
    };
}

#pragma mark -

- (void)dealloc {
    if ( _style ) [_attrM addAttribute:NSParagraphStyleAttributeName value:_style range:_rangeAll(_attrM)];
    self.range(_rangeAll(_attrM));
}

- (NSMutableParagraphStyle *)style {
    if ( _style ) return _style;
    _style = [NSMutableParagraphStyle new];
    return _style;
}

#pragma mark -

inline static NSRange _rangeAll(NSAttributedString *attr) {
    return NSMakeRange(0, attr.length);
}

@end

