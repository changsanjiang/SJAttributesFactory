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
    NSAttributedString *attr = [SJAttributesFactory alterStr:str block:^(SJAttributesFactory *alter) {
        // 修改整体
        alter.font([UIFont systemFontOfSize:20]).backgroundColor([UIColor grayColor]).lineSpacing(25).alignment(NSTextAlignmentRight);
        
        UIColor *color = [UIColor greenColor];
        NSRange range = NSMakeRange(webAddress.length, phone.length);
        // 修改指定范围
        alter.nextFont([UIFont boldSystemFontOfSize:20]).nextFontColor(color).range(range);
        alter.nextFontColor([UIColor redColor]).nextUnderline([UIColor cyanColor]).nextBackgroundColor([UIColor yellowColor]).nextStrikethough([UIColor brownColor]).nextLetterSpacing(2).range(NSMakeRange(0, webAddress.length));
    }];
    
    NSMutableAttributedString *attrM = (NSMutableAttributedString *)attr;
//    [attrM addAttribute:NSKernAttributeName value:@(1) range:NSMakeRange(0, str.length)];
    [_testBtn setAttributedTitle:attrM forState:UIControlStateNormal];
}

@end

