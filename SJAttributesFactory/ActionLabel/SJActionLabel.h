//
//  SJActionLabel.h
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/12.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SJCTData.h"

@interface SJActionLabel : UIView

@property (nonatomic, strong) id text;
@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, strong) SJCTData *data;

@end
