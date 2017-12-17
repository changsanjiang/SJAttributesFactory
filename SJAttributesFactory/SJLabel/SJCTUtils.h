//
//  SJCTUtils.h
//  Test
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJCTData.h"

@interface SJCTUtils : NSObject

+ (SJCTLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(SJCTData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(SJCTData *)data;

@end
