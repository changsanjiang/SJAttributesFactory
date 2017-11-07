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
    
    NSString *webAddress = @"webAddress:http://www.baidu.com\n";
    NSString *phone = @"phone:12345678901\n";
    NSString *name = @"name:SanJiang\n";
    _testBtn.titleLabel.numberOfLines = 0;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@", webAddress, phone, name];
    NSAttributedString *attr = [SJAttributesFactory alterStr:str block:^(SJAttributesFactory *worker) {
        // 修改整体
        worker
        .font([UIFont systemFontOfSize:20])
        .backgroundColor([UIColor grayColor])
        .lineSpacing(25)
        .alignment(NSTextAlignmentRight)
        .insertImage([UIImage imageNamed:@"sample"], CGSizeMake(20, 20), 10);
        
        UIColor *color = [UIColor greenColor];
        NSRange range = NSMakeRange(webAddress.length, phone.length);
        // 修改指定范围
        worker.nextFont([UIFont boldSystemFontOfSize:20]).nextFontColor(color).range(range);
        
        worker
        .nextFontColor([UIColor blueColor])
        .nextUnderline([UIColor cyanColor])
        .nextBackgroundColor([UIColor orangeColor])
        .nextStrikethough([UIColor brownColor])
        .nextStroke(-1, [UIColor blackColor])
        .nextLetterSpacing(2)
        .nextLetterpress()
        .range(NSMakeRange(0, webAddress.length));
    }];
    
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

@end

