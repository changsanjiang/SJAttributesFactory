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
@property (nonatomic, strong, readwrite) NSNumber *r_nextExpansion;
@property (nonatomic, strong, readwrite) UIColor *r_nextFontColor;
@property (nonatomic, strong, readwrite) NSShadow *r_nextShadow;
@property (nonatomic, strong, readwrite) NSNumber *r_nextUnderline;
@property (nonatomic, strong, readwrite) UIColor *r_nextUnderlineColor;
@property (nonatomic, strong, readwrite) NSNumber *r_nextStrikethough;
@property (nonatomic, strong, readwrite) UIColor *r_nextStrikethoughColor;
@property (nonatomic, strong, readwrite) UIColor *r_nextBackgroundColor;
@property (nonatomic, strong, readwrite) NSNumber *r_nextLetterSpacing;
@property (nonatomic, strong, readwrite) NSNumber *r_nextStrokeBorder;
@property (nonatomic, strong, readwrite) UIColor *r_nextStrokeColor;
@property (nonatomic, assign, readwrite) BOOL r_nextLetterpress;
@property (nonatomic, assign, readwrite) BOOL r_nextLink;
@property (nonatomic, strong, readwrite) NSNumber *r_nextOffset;
@property (nonatomic, strong, readwrite) NSNumber *r_nextObliqueness;

@end

@implementation SJAttributesFactory

@synthesize attrM = _attrM;
@synthesize style = _style;

+ (NSAttributedString *)alterStr:(NSString *)str block:(void(^)(SJAttributesFactory *worker))block {
    return [self alterAttrStr:[[NSMutableAttributedString alloc] initWithString:str] block:block];
}

+ (NSAttributedString *)alterAttrStr:(NSAttributedString *)attrStr block:(void(^)(SJAttributesFactory *worker))block {
    NSAssert(attrStr, @"param must not be empty!");
    NSMutableAttributedString *attrStrM = attrStr.mutableCopy;
    SJAttributesFactory *worker = [[SJAttributesFactory alloc] initWithAttr:attrStrM];
    block(worker);
    [worker finishingOperation];
    return attrStrM;
}

+ (NSAttributedString *)alterWithImage:(UIImage *)image offset:(CGPoint)offset size:(CGSize)size block:(void(^)(SJAttributesFactory *worker))block {
    return [self alterAttrStr:[self attrStrWithImage:image offset:offset size:size] block:block];
}

+ (NSAttributedString *)alterWithBlock:(void(^)(SJAttributesFactory *worker))block {
    return [self alterStr:@"" block:block];
}

+ (NSAttributedString *)attrStrWithImage:(UIImage *)image offset:(CGPoint)offset size:(CGSize)size {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachment.image = image;
    attachment.bounds = CGRectMake(offset.x, offset.y, size.width, size.height);
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

- (instancetype)initWithAttr:(NSMutableAttributedString *)attr {
    self = [super init];
    if ( !self ) return nil;
    _attrM = attr;
    return self;
}

- (void)finishingOperation {
    if ( _style ) self.paragraphStyle(_style);
}

#pragma mark -

- (SJAttributesFactory *(^)(UIFont *font))font {
    return ^ SJAttributesFactory *(UIFont *font) {
        [_attrM addAttribute:NSFontAttributeName value:font range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(float))expansion {
    return ^ SJAttributesFactory *(float expansion) {
        [_attrM addAttribute:NSExpansionAttributeName value:@(expansion) range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *))fontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        [_attrM addAttribute:NSForegroundColorAttributeName value:fontColor range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory *(^)(NSShadow *))shadow {
    return ^ SJAttributesFactory *(NSShadow *shadow) {
        [_attrM addAttribute:NSShadowAttributeName value:shadow range:_rangeAll(_attrM)];
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

- (SJAttributesFactory * _Nonnull (^)(float))paragraphSpacing {
    return ^ SJAttributesFactory *(float paragraphSpacing) {
        self.style.paragraphSpacing = paragraphSpacing;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(float))paragraphSpacingBefore {
    return ^ SJAttributesFactory *(float paragraphSpacingBefore) {
        self.style.paragraphSpacingBefore = paragraphSpacingBefore;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(float))firstLineHeadIndent {
    return ^ SJAttributesFactory *(float firstLineHeadIndent) {
        self.style.firstLineHeadIndent = firstLineHeadIndent;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(float))headIndent {
    return ^ SJAttributesFactory *(float headIndent) {
        self.style.headIndent = headIndent;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(float))tailIndent {
    return ^ SJAttributesFactory *(float tailIndent) {
        self.style.tailIndent = tailIndent;
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

- (SJAttributesFactory * _Nonnull (^)(NSLineBreakMode))lineBreakMode {
    return ^ SJAttributesFactory *(NSLineBreakMode mode) {
        self.style.lineBreakMode = mode;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSUnderlineStyle, UIColor * _Nonnull))underline {
    return ^ SJAttributesFactory *(NSUnderlineStyle style, UIColor *color) {
        [_attrM addAttribute:NSUnderlineStyleAttributeName value:@(style) range:_rangeAll(_attrM)];
        [_attrM addAttribute:NSUnderlineColorAttributeName value:color range:_rangeAll(_attrM)];
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSUnderlineStyle, UIColor * _Nonnull))strikethrough {
    return ^ SJAttributesFactory *(NSUnderlineStyle style, UIColor *color) {
        [_attrM addAttribute:NSStrikethroughStyleAttributeName value:@(style) range:_rangeAll(_attrM)];
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

- (SJAttributesFactory *(^)(float))obliqueness {
    return ^ SJAttributesFactory *(float obliqueness) {
        [_attrM addAttribute:NSObliquenessAttributeName value:@(obliqueness) range:_rangeAll(_attrM)];
        return self;
    };
}

#pragma mark -

- (void (^)(NSRange))range {
    return ^(NSRange range) {
        if ( _r_nextFont ) {
            [_attrM addAttribute:NSFontAttributeName value:_r_nextFont range:range];
            _r_nextFont = nil;
        }
        if ( _r_nextExpansion ) {
            [_attrM addAttribute:NSExpansionAttributeName value:_r_nextExpansion range:range];
            _r_nextExpansion = nil;
        }
        if ( _r_nextFontColor ) {
            [_attrM addAttribute:NSForegroundColorAttributeName value:_r_nextFontColor range:range];
            _r_nextFontColor = nil;
        }
        if ( _r_nextUnderline ) {
            [_attrM addAttribute:NSUnderlineStyleAttributeName value:_r_nextUnderline range:range];
            _r_nextUnderline = nil;
        }
        if ( _r_nextUnderlineColor ) {
            [_attrM addAttribute:NSUnderlineColorAttributeName value:_r_nextUnderlineColor range:range];
            _r_nextUnderlineColor = nil;
        }
        if ( _r_nextBackgroundColor ) {
            [_attrM addAttribute:NSBackgroundColorAttributeName value:_r_nextBackgroundColor range:range];
            _r_nextBackgroundColor = nil;
        }
        if ( _r_nextLetterSpacing ) {
            [_attrM addAttribute:NSKernAttributeName value:_r_nextLetterSpacing range:range];
            _r_nextLetterSpacing = nil;
        }
        if ( _r_nextStrikethough ) {
            [_attrM addAttribute:NSStrikethroughStyleAttributeName value:_r_nextStrikethough range:range];
            _r_nextStrikethough = nil;
        }
        if ( _r_nextStrikethoughColor ) {
            [_attrM addAttribute:NSStrikethroughColorAttributeName value:_r_nextStrikethoughColor range:range];
            _r_nextStrikethoughColor = nil;
        }
        if ( _r_nextStrokeBorder ) {
            [_attrM addAttribute:NSStrokeWidthAttributeName value:_r_nextStrokeBorder range:range];
            _r_nextStrokeBorder = nil;
        }
        if ( _r_nextStrokeColor ) {
            [_attrM addAttribute:NSStrokeColorAttributeName value:_r_nextStrokeColor range:range];
            _r_nextStrokeColor = nil;
        }
        if ( _r_nextLetterpress ) {
            [_attrM addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:range];
            _r_nextLetterpress = NO;
        }
        if ( _r_nextLink ) {
            [_attrM addAttribute:NSLinkAttributeName value:@(1) range:range];
            _r_nextLink = NO;
        }
        if ( _r_nextOffset ) {
            [_attrM addAttribute:NSBaselineOffsetAttributeName value:_r_nextOffset range:range];
            _r_nextOffset = nil;
        }
        if ( _r_nextObliqueness ) {
            [_attrM addAttribute:NSObliquenessAttributeName value:_r_nextObliqueness range:range];
            _r_nextObliqueness = nil;
        }
        if ( _r_nextShadow ) {
            [_attrM addAttribute:NSShadowAttributeName value:_r_nextShadow range:range];
            _r_nextShadow = nil;
        }
    };
}

- (SJAttributesFactory *(^)(UIFont *font))nextFont {
    return ^ SJAttributesFactory *(UIFont *font) {
        _r_nextFont = font;
        return self;
    };
}

- (SJAttributesFactory *(^)(float))nextExpansion {
    return ^ SJAttributesFactory *(float expansion) {
        _r_nextExpansion = @(expansion);
        return self;
    };
}

- (SJAttributesFactory *(^)(UIColor *color))nextFontColor {
    return ^ SJAttributesFactory *(UIColor *fontColor) {
        _r_nextFontColor = fontColor;
        return self;
    };
}

- (SJAttributesFactory *(^)(NSShadow *))nextShadow {
    return ^ SJAttributesFactory *(NSShadow *nextShadow) {
        _r_nextShadow = nextShadow;
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

- (SJAttributesFactory * _Nonnull (^)(NSUnderlineStyle, UIColor * _Nonnull))nextUnderline {
    return ^ SJAttributesFactory *(NSUnderlineStyle style, UIColor *color) {
        _r_nextUnderline = @(style);
        _r_nextUnderlineColor = color;
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSUnderlineStyle, UIColor * _Nonnull))nextStrikethough {
    return ^ SJAttributesFactory *(NSUnderlineStyle style, UIColor *color) {
        _r_nextStrikethough = @(style);
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

- (SJAttributesFactory *(^)(void))nextLink {
    return ^ SJAttributesFactory *(void) {
        _r_nextLink = YES;
        return self;
    };
}

- (SJAttributesFactory *(^)(float))nextOffset {
    return ^ SJAttributesFactory *(float nextOffset) {
        _r_nextOffset = @(nextOffset);
        return self;
    };
}

- (SJAttributesFactory *(^)(float))nextObliqueness {
    return ^ SJAttributesFactory *(float nextObliqueness) {
        _r_nextObliqueness = @(nextObliqueness);
        return self;
    };
}

#pragma mark -

- (SJAttributesFactory *(^)(UIImage *, CGPoint, CGSize, NSInteger))insertImage {
    return ^ SJAttributesFactory *(UIImage *image, CGPoint offset, CGSize size, NSInteger index) {
        if ( -1 == index ) index = _attrM.length;
        self.insertAttr([[self class] attrStrWithImage:image offset:offset size:size], index);
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSAttributedString * _Nonnull, NSInteger))insertAttr {
    return ^ SJAttributesFactory *(NSAttributedString *attr, NSInteger index) {
        if ( -1 == index ) index = _attrM.length;
        [_attrM insertAttributedString:attr atIndex:index];
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSString * _Nonnull, NSInteger))insertText {
    return ^ SJAttributesFactory *(NSString *text, NSInteger index) {
        if ( -1 == index ) index = _attrM.length;
        self.insertAttr([[NSAttributedString alloc] initWithString:text], index);
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSRange, id value))replace {
    return ^ SJAttributesFactory *(NSRange range, id value) {
        if ( [value isKindOfClass:[NSString class]] ) {
            [_attrM replaceCharactersInRange:range withString:value];
        }
        else if ( [value isKindOfClass:[NSAttributedString class]] ) {
            [_attrM replaceCharactersInRange:range withAttributedString:value];
        }
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSRange))removeText {
    return ^ SJAttributesFactory *(NSRange range) {
        [_attrM deleteCharactersInRange:range];
        return self;
    };
}

- (SJAttributesFactory * _Nonnull (^)(NSAttributedStringKey _Nonnull, NSRange))removeAttribute {
    return ^ SJAttributesFactory *(NSAttributedStringKey key, NSRange range) {
        [_attrM removeAttribute:key range:range];
        return self;
    };
}

- (void (^)(void))clean {
    return ^ () {
        [_attrM enumerateAttributesInRange:_rangeAll(_attrM) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            [attrs enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                // 字体大小保持不变
                if ( [key isEqualToString:NSFontAttributeName] ) return;
                self.removeAttribute(key, range);
            }];
        }];
    };
}

#pragma mark -

- (NSMutableParagraphStyle *)style {
    if ( _style ) return _style;
    _style = [NSMutableParagraphStyle new];
    return _style;
}

#pragma mark - Other
- (NSInteger)length {
    return _attrM.length;
}

- (CGFloat (^)(NSRange))width {
    return ^ CGFloat (NSRange range) {
        return self.size(range).width;
    };
}

- (CGSize (^)(NSRange))size {
    return ^ CGSize (NSRange range) {
        NSAttributedString *attr = [_attrM attributedSubstringFromRange:range];
        return [self attr:attr boundsWithWidth:CGFLOAT_MAX height:CGFLOAT_MAX].size;
    };
}

- (CGRect (^)(CGFloat))boundsForMaxWidth {
    return ^ CGRect (CGFloat maxWidth) {
        return [self attr:_attrM boundsWithWidth:maxWidth height:CGFLOAT_MAX];
    };
}

- (CGRect (^)(CGFloat))boundsForMaxHeight {
    return ^ CGRect (CGFloat maxHeight) {
        return [self attr:_attrM boundsWithWidth:CGFLOAT_MAX height:maxHeight];
    };
}

- (CGRect)attr:(NSAttributedString *)attr boundsWithWidth:(CGFloat)width height:(CGFloat)height {
    if ( _style ) self.paragraphStyle(_style);
    __block BOOL isSetFont = NO;
    [attr enumerateAttributesInRange:_rangeAll(attr) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        [attrs enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ( ![key isEqualToString:NSFontAttributeName] ) return;
            isSetFont = YES;
            *stop = YES;
        }];
    }];
    NSAssert(isSetFont, @"You need to set it font!");
    return [attr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
}

#pragma mark -

inline static NSRange _rangeAll(NSAttributedString *attr) {
    return NSMakeRange(0, attr.length);
}

@end

