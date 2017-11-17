//
//  SJAttributeEditContent.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributeEditContent : NSObject

/// 获取当前文本的长度
@property (nonatomic, assign, readonly) NSInteger length;

/// 获取指定范围的文本
@property (nonatomic, copy, readonly) NSAttributedString *(^attrStrByRange)(NSRange range);

/*!
 *  Insert a image at the specified position.
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入图片.
 *  如果 index = -1, 将会插到文本最后
 **/
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^insertImage)(UIImage *image, NSInteger index, CGPoint offset, CGSize size);
/*!
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入文本.
 *  如果 index = -1, 将会插到文本最后.
 **/
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^insertAttr)(NSAttributedString *attrStr, NSInteger index);
/*!
 *  You can get the length of the text through [worker.length].
 *  If index = -1, it will be inserted at the end of the text.
 *
 *  可以通过 worker.length 来获取文本的length
 *  指定位置 插入文本.
 *  如果 index = -1, 将会插到文本最后
 **/
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^insertText)(NSString *text, NSInteger index);
/**
 *  insert = NSString or NSAttributedString or UIImage
 *  insert(string, 0)
 *  insert(attributedString, 0)
 *  insert([UIImage imageNamed:name], 10, CGPointMake(0, -20), CGSizeMake(50, 50))
 */
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^insert)(id strOrAttrStrOrImg, ...);


#pragma mark - Replace
/// value == NSString Or NSAttributedString
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^replace)(NSRange range, id strOrAttrStr);
/// oldPart and newPart == NSString Or NSAttributedString
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^replaceIt)(id oldPart, id newPart);


#pragma mark - Remove
/// 指定范围 删除文本
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^removeText)(NSRange range);
/// 指定范围 删除属性
@property (nonatomic, copy, readonly) SJAttributeEditContent *(^removeAttribute)(NSAttributedStringKey key, NSRange range);
/// 除字体大小, 清除文本其他属性
@property (nonatomic, copy, readonly) void (^clean)(void);

@end
