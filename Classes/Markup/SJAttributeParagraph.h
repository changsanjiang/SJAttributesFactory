//
//  SJAttributeParagraph.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributeParagraph : NSObject

/// 行间隔
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^lineSpacing)(float spacing);
/// 段后间隔
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^paragraphSpacing)(float paragraphSpacing);
/// 段前间隔
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^paragraphSpacingBefore)(float paragraphSpacingBefore);
/// 首行缩进
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^firstLineHeadIndent)(float padding);
/// 左缩进
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^headIndent)(float headIndent);
/// 右缩进(正值从左算起, 负值从右算起)
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^tailIndent)(float tailIndent);
/// 对齐方式
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^alignment)(NSTextAlignment alignment);
/// line break mode
@property (nonatomic, copy, readonly) SJAttributeParagraph *(^lineBreakMode)(NSLineBreakMode mode);

@end
