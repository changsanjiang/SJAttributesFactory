//
//  ViewController.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "ViewController.h"

#import "SJAttributesFactory.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *webAddress = @"address:http://www.baidu.com\n";
    NSString *phone = @"phone:17621259560\n";
    NSString *name = @"name:SanJiang\n";
    _testBtn.titleLabel.numberOfLines = 0;
    
    NSAttributedString *attr = [SJAttributesFactory alterStr:[NSString stringWithFormat:@"%@%@%@", webAddress, phone, name] block:^(SJAttributesFactory *alter) {
        UIColor *color = [UIColor redColor];
        
        // 修改整体
        alter.font(20).fontColor(color).lineSpacing(25).alignment(NSTextAlignmentRight);
        
        
        color = [UIColor greenColor];
        NSRange range = NSMakeRange(webAddress.length, phone.length);
        
        // 修改指定范围
        alter.nextBoldFont(25).nextFontColor(color).range(range);
    }];
    
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

@end

