//
//  SJLabelViewController.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJLabelViewController.h"
#import "SJLabel.h"

@interface SJLabelViewController ()

@property (nonatomic, strong) SJLabel *label;

@end

@implementation SJLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [[SJLabel alloc] initWithText:@"我被班主任杨老师叫到办公室，当时上课铃刚响，杨老师过来找我，我挺奇怪的，什么事啊，可以连课都不上？当时办公室里就我们两个人。杨老师拿出手机，让我看她拍的一张照片，是我们班最近一次班级活动时照的。我们仨坐在一张椅子上，我坐在中间，皱着个眉头，小喵托着腮帮子，小桐则靠着椅背坐着。" font:[UIFont systemFontOfSize:16] textColor:[UIColor orangeColor] lineSpacing:8];
    _label.center = self.view.center;
    _label.bounds = CGRectMake(0, 0, self.view.frame.size.width, 200);
    _label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_label];
    
    // Do any additional setup after loading the view.
}


- (IBAction)change:(id)sender {
    _label.text = @"// Do any additional setup after loading the view.";
    _label.font = [UIFont systemFontOfSize:20];
    _label.textColor = [UIColor redColor];
}

@end
