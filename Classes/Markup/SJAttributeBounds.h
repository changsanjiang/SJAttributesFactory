//
//  SJAttributeBounds.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/11/17.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttributeBounds : NSObject

/// 获取指定范围的宽度. (必须设置过字体)
@property (nonatomic, copy, readonly) CGFloat(^width)(NSRange range);

/// 获取指定范围的大小. (必须设置过字体)
@property (nonatomic, copy, readonly) CGSize(^size)(NSRange range);

/// 获取指定范围的大小. (必须设置过字体)
@property (nonatomic, copy, readonly) CGRect(^byMaxWidth)(CGFloat maxWidth);

/// 获取指定范围的大小. (必须设置过字体)
@property (nonatomic, copy, readonly) CGRect(^byMaxHeight)(CGFloat maxHeight);

@end
