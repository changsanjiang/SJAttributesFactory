//
//  SJCTData.h
//  Test
//
//  Created by BlueDancer on 2017/12/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "SJCTImageData.h"
#import "SJCTLinkData.h"

@interface SJCTData : NSObject

@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray<SJCTImageData *> *imageDataArray;
@property (nonatomic, strong) NSArray<SJCTLinkData *> *linkDataArray;

@end
