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
            tips = @"左右图文";
            attr = [SJAttributesFactory alterStr:@"9999\n9999999" block:^(SJAttributesFactory * _Nonnull worker) {
                worker
                .insertImage([UIImage imageNamed:@"sample2"], CGPointMake(0, -20), CGSizeMake(50, 50), 0)
                .font([UIFont boldSystemFontOfSize:14])
                .fontColor([UIColor whiteColor]);
            }];
        }
            break;
        case 1: {
            tips = @"上下图文";
            attr = [SJAttributesFactory alterStr:@"9999" block:^(SJAttributesFactory * _Nonnull worker) {
                worker
                .insertText(@"\n", 0)
                .insertImage([UIImage imageNamed:@"sample2"], CGPointZero, CGSizeMake(50, 50), 0)
                .lineSpacing(8) // 加点行间隔
                .alignment(NSTextAlignmentCenter)
                .font([UIFont boldSystemFontOfSize:14])
                .fontColor([UIColor whiteColor]);
            }];
        }
            break;
        case 2: {
            tips = @"下划线 + 删除线";
            attr = [SJAttributesFactory alterStr:@"$ 999" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.font([UIFont systemFontOfSize:40]);
                worker.underline(NSUnderlineByWord | NSUnderlinePatternSolid | NSUnderlineStyleDouble, [UIColor yellowColor]).strikethrough(NSUnderlineByWord | NSUnderlinePatternSolid | NSUnderlineStyleDouble, [UIColor redColor]);
            }];
        }
            break;
        case 3: {
            tips = @"字体放大";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.alignment(NSTextAlignmentCenter);
                worker.nextExpansion(1).range(NSMakeRange(0, 4));
            }];
        }
            break;
        case 4: {
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
        case 5: {
            tips = @"背景颜色 + 字体间隔";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.backgroundColor([UIColor orangeColor]).alignment(NSTextAlignmentCenter);
                worker.nextLetterSpacing(8).range(NSMakeRange(0, 4));
            }];
        }
            break;
        case 6: {
            tips = @"凸版 + 倾斜";
            attr = [SJAttributesFactory alterStr:@"我的故乡\n我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.letterpress().obliqueness(0.2);
            }];
        }
            break;
        case 7: {
            tips = @"指定位置插入文本";
            attr = [SJAttributesFactory alterStr:@"我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                NSLog(@"插入前: %zd", worker.length);
                
                worker.insertText(@", 在哪里?", 4);
                
                NSLog(@"插入后: %zd", worker.length);
            }];
        }
            break;
        case 8: {
            tips = @"指定范围删除文本";
            attr = [SJAttributesFactory alterStr:@"我的故乡" block:^(SJAttributesFactory * _Nonnull worker) {
                worker.removeText(NSMakeRange(0, 2));
            }];
        }
            break;
        case 9: {
            tips = @"清除";
            attr = _testBtn.currentAttributedTitle;
            attr = [SJAttributesFactory alterAttrStr:attr block:^(SJAttributesFactory * _Nonnull worker) {
                worker.clean();
            }];
        }
            break;
    }
    
    if ( !attr ) return;
    _tipsLabel.text = tips;
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
    
    NSLog(@"------------- end -------------");
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"demo %zd", indexPath.row];
    return cell;
}

@end

