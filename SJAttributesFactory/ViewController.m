//
//  ViewController.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "ViewController.h"
#import "SJAttributesFactory.h"

static NSString *UITableViewCellID = @"UITableViewCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

- (void)_setupViews {
    
    // test btn
    self.testBtn.layer.cornerRadius = 8;
    self.testBtn.backgroundColor = [UIColor lightGrayColor];
    self.testBtn.titleLabel.numberOfLines = 0;
    [self.testBtn setTitle:@"请选择 demo " forState:UIControlStateNormal];
    
    // table view
    [self.tableView registerClass:NSClassFromString(UITableViewCellID) forCellReuseIdentifier:UITableViewCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAttributedString *attr = nil;
    NSString *tips = nil;
    switch (indexPath.row) {
        case 0: {
            tips = @"上图下字";
            
            attr = [SJAttributesFactory alterStr:@"\n9999" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.insertImage([UIImage imageNamed:@"sample2"], CGSizeMake(50, 50), 0)
                .lineSpacing(4)
                .alignment(NSTextAlignmentCenter)
                .font([UIFont boldSystemFontOfSize:14])
                .fontColor([UIColor whiteColor]);
            }];
        }
            break;
        case 1: {
            tips = @"下划线 + 删除线";
            attr = [SJAttributesFactory alterStr:@"$ 999" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.underline([UIColor yellowColor]).strikethrough([UIColor redColor]);
            }];
        }
            break;
        case 2: {
            tips = @"字体放大";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.alignment(NSTextAlignmentCenter);
                worker.nextExpansion(1).range(NSMakeRange(0, 4));
            }];
        }
            break;
        case 3: {
            tips = @"字体阴影";
            attr = [SJAttributesFactory alterStr:@"我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                NSShadow *shadow = [NSShadow new];
                shadow.shadowColor = [UIColor greenColor];
                shadow.shadowOffset = CGSizeMake(1, 1);
                worker.font([UIFont boldSystemFontOfSize:40])
                .shadow(shadow);
            }];
        }
            break;
        case 4: {
            tips = @"背景颜色 + 字体间隔";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.backgroundColor([UIColor orangeColor]).alignment(NSTextAlignmentCenter);
                worker.nextLetterSpacing(8).range(NSMakeRange(0, 4));
            }];
        }
            break;
        case 5: {
            tips = @"凸版 + 倾斜";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.letterpress().obliqueness(0.2);
            }];
        }
    }
    
    if ( !attr ) return;
    _tipsLabel.text = tips;
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"demo %zd", indexPath.row];
    return cell;
}

@end

