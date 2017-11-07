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
        //MARK: 修改整体
        worker
        .font([UIFont systemFontOfSize:12])     // 字体
        .expansion(0.2)                         // 字体粗细
        .backgroundColor([UIColor grayColor])   // 背景颜色
        .lineSpacing(25)                        // 行间距
        .alignment(NSTextAlignmentRight)        // 对齐方式
        .obliqueness(0.4)                       // 倾斜度
        .insertImage([UIImage imageNamed:@"sample"], CGSizeMake(20, 20), 10); // 指定位置插入图片
        
        UIColor *color = [UIColor greenColor];
        NSRange range = NSMakeRange(webAddress.length, phone.length);
        //MARK: 修改指定范围
        worker.nextFont([UIFont boldSystemFontOfSize:20]).nextFontColor(color).range(range);
        
        worker
        .nextFontColor([UIColor blueColor])
        .nextBackgroundColor([UIColor orangeColor])
        .nextStrikethough([UIColor brownColor])
        .nextStroke(-1, [UIColor blackColor])
        .nextLetterSpacing(2)
        .nextLetterpress()
        .range(NSMakeRange(0, webAddress.length));  // 请指定修改的范围
        
        worker.nextOffset(10).range(NSMakeRange(5, 10));
    }];
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

@end

