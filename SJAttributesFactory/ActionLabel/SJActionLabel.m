//
//  SJActionLabel.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/12.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJActionLabel.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreText/CoreText.h>


@interface SJActionLabel ()

@end

@implementation SJActionLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    if ( _data ) { CTFrameDraw(_data.frameRef, context);}
}

@end

