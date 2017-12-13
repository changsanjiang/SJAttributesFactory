//
//  SJCTData.m
//  Test
//
//  Created by BlueDancer on 2017/12/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJCTData.h"

@implementation SJCTData

- (void)setFrameRef:(CTFrameRef)frameRef {
    if ( _frameRef != frameRef ) {
        if ( _frameRef ) CFRelease(_frameRef);
    }
    if ( frameRef ) CFRetain(_frameRef = frameRef);
}

- (void)dealloc {
    if ( _frameRef ) CFRelease(_frameRef);
}

@end
