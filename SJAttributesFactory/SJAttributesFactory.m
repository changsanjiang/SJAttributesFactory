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

@property (nonatomic, strong, readwrite) UIFont *r_nextFont;
@property (nonatomic, strong, readwrite) UIColor *r_nextFontColor;
@property (nonatomic, assign, readwrite) BOOL r_nextUnderline;
@property (nonatomic, strong, readwrite) UIColor *r_nextUnderlineColor;
@property (nonatomic, assign, readwrite) BOOL r_nextStrikethough;
@property (nonatomic, strong, readwrite) UIColor *r_nextStrikethoughColor;
@property (nonatomic, strong, readwrite) UIColor *r_nextBackgroundColor;
@property (nonatomic, strong, readwrite) NSNumber *r_nextLetterSpacing;
@property (nonatomic, strong, readwrite) NSNumber *r_nextStrokeBorder;
@property (nonatomic, strong, readwrite) UIColor *r_nextStrokeColor;
@property (nonatomic, assign, readwrite) BOOL r_nextLetterpress;
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

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *worker))block {
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:str];
    if ( block ) block([[SJAttributesFactory alloc] initWithAttr:attrStrM]);
    return attrStrM;
}

#pragma mark -

- (SJAttributesFactory *(^)(UIFont *font))font {
    return ^ SJAttributesFactory *(UIFont *font) {
        [_attrM addAttribute:NSFontAttributeName value:font range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))fontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        [_attrM addAttribute:NSForegroundColorAttributeName value:fontColor range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))backgroundColor {
    return ^ SJAttributesFactory *(UIColor *color) {
        [_attrM addAttribute:NSBackgroundColorAttributeName value:color range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(float))lineSpacing {
    return ^ SJAttributesFactory *(float lineSpacing) {
        self.style.lineSpacing = lineSpacing;
        return self;
    };
}

- (SJAttributesFactory *(^)(float))letterSpacing {
    return ^ SJAttributesFactory *(float spacing) {
        [_attrM addAttribute:NSKernAttributeName value:@(spacing) range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(NSTextAlignment))alignment {
    return ^ SJAttributesFactory *(NSTextAlignment alignment) {
        self.style.alignment = alignment;
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))underline {
    return ^ SJAttributesFactory *(UIColor *color) {
        [_attrM addAttribute:NSUnderlineStyleAttributeName value:@(1) range:_rangeAll(_attrM)];
        [_attrM addAttribute:NSUnderlineColorAttributeName value:color range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))strikethrough {
    return ^ SJAttributesFactory *(UIColor *color) {
        [_attrM addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:_rangeAll(_attrM)];
        [_attrM addAttribute:NSStrikethroughColorAttributeName value:color range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(float, UIColor *))stroke {
    return ^ SJAttributesFactory *(float border, UIColor *color) {
        [_attrM addAttribute:NSStrokeWidthAttributeName value:@(border) range:_rangeAll(_attrM)];
        [_attrM addAttribute:NSStrokeColorAttributeName value:color range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(void))letterpress {
    return ^ SJAttributesFactory *(void) {
        [_attrM addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(NSParagraphStyle *))paragraphStyle {
    return ^ SJAttributesFactory *(NSParagraphStyle *style) {
        [_attrM addAttribute:NSParagraphStyleAttributeName value:style range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIImage *, CGSize, NSInteger))insertImage {
    return ^ SJAttributesFactory *(UIImage *image, CGSize size, NSInteger index) {
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, size.width, size.height);
        NSAttributedString *attr = [NSAttributedString attributedStringWithAttachment:attachment];
        [_attrM insertAttributedString:attr atIndex:index];
        return self;
    };
}

#pragma mark -

- (void (^)(NSRange))range {
    return ^(NSRange range) {
        if ( _r_nextFont ) [_attrM addAttribute:NSFontAttributeName value:_r_nextFont range:range];
        if ( _r_nextFontColor ) [_attrM addAttribute:NSForegroundColorAttributeName value:_r_nextFontColor range:range];
        if ( _r_nextUnderline ) [_attrM addAttribute:NSUnderlineStyleAttributeName value:@(1) range:range];
        if ( _r_nextUnderlineColor ) [_attrM addAttribute:NSUnderlineColorAttributeName value:_r_nextUnderlineColor range:range];
        if ( _r_nextBackgroundColor ) [_attrM addAttribute:NSBackgroundColorAttributeName value:_r_nextBackgroundColor range:range];
        if ( _r_nextLetterSpacing ) [_attrM addAttribute:NSKernAttributeName value:_r_nextLetterSpacing range:range];
        if ( _r_nextStrikethough ) [_attrM addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:range];
        if ( _r_nextStrikethoughColor ) [_attrM addAttribute:NSStrikethroughColorAttributeName value:_r_nextStrikethoughColor range:range];
        if ( _r_nextStrokeBorder ) [_attrM addAttribute:NSStrokeWidthAttributeName value:_r_nextStrokeBorder range:range];
        if ( _r_nextStrokeColor ) [_attrM addAttribute:NSStrokeColorAttributeName value:_r_nextStrokeColor range:range];
        if ( _r_nextLetterpress ) [_attrM addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:range];
        
        
        // clear
        _r_nextFont = nil;
        _r_nextFontColor = nil;
        _r_nextUnderline = NO;
        _r_nextUnderlineColor = nil;
        _r_nextBackgroundColor = nil;
        _r_nextStrikethough = NO;
        _r_nextStrikethoughColor = nil;
        _r_nextLetterSpacing = nil;
        _r_nextStrokeBorder = nil;
        _r_nextStrokeColor = nil;
        _r_nextLetterpress = NO;
    };
}

- (SJAttributesFactory *(^)(UIFont *font))nextFont {
    return ^ SJAttributesFactory *(UIFont *font) {
        _r_nextFont = font;
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *color))nextFontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        _r_nextFontColor = fontColor;
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))nextBackgroundColor {
    return ^ SJAttributesFactory *(UIColor *color) {
        _r_nextBackgroundColor = color;
        return self;
    };
}

- (SJAttributesFactory *(^)(float))nextLetterSpacing {
    return ^ SJAttributesFactory *(float spacing) {
        _r_nextLetterSpacing = @(spacing);
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))nextUnderline {
    return ^ SJAttributesFactory *(UIColor *color) {
        _r_nextUnderline = YES;
        _r_nextUnderlineColor = color;
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))nextStrikethough {
    return ^ SJAttributesFactory *(UIColor *color) {
        _r_nextStrikethough = YES;
        _r_nextStrikethoughColor = color;
        return self;
    };
}

- (SJAttributesFactory *(^)(float, UIColor *))nextStroke {
    return ^ SJAttributesFactory *(float border, UIColor *color){
        _r_nextStrokeBorder = @(border);
        _r_nextStrokeColor = color;
        return self;
    };
}

- (SJAttributesFactory *(^)(void))nextLetterpress {
    return ^ SJAttributesFactory *(void) {
        _r_nextLetterpress = YES;
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

