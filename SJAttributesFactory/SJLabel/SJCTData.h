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
#import "SJCTFrameParserConfig.h"

@interface SJCTData : NSObject<NSCopying>

@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray<SJCTImageData *> *imageDataArray;
@property (nonatomic, strong) NSArray<SJCTLinkData *> *linkDataArray;
@property (nonatomic, strong) NSAttributedString *attrStr;
@property (nonatomic, strong) SJCTFrameParserConfig *config;

- (void)drawingWithContext:(CGContextRef)context;

@end
