//
//  ViewController.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "ViewController.h"
#import "SJAttributeWorker.h"

static NSString *UITableViewCellID = @"UITableViewCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

- (void)_setupViews {
    
    // test btn
    self.testLabel.layer.cornerRadius = 8;
    self.testLabel.clipsToBounds = YES;
    self.testLabel.backgroundColor = [UIColor lightGrayColor];
    self.testLabel.numberOfLines = 0;
    self.testLabel.text = @"请选择 demo ";

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
            tips = @"正则";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"叶秋笑了笑，抬手取下了衔在嘴角的烟头。银白的烟灰已经结成了长长一串，但在叶秋挥舞着鼠标敲打着键盘施展操作的过程中却没有被震落分毫。摘下的烟头很快被掐灭在了桌上的一个形状古怪的烟灰缸里，叶秋的手飞快地回到了键盘，正准备对对手说点什么，房门却突得咣一声被人打开了。", 0);
                make.font([UIFont boldSystemFontOfSize:14]).textColor([UIColor blueColor]);
                
                // 匹配所有`叶秋`
                make.regexp(@"叶秋", ^(SJAttributesRangeOperator * _Nonnull matched) {
                    matched.textColor([UIColor redColor]);
                    matched.underLine([SJUnderlineAttribute underLineWithStyle:NSUnderlineStyleSingle | NSUnderlinePatternSolid color:[UIColor orangeColor]]);
                });
                
                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
            });
        }
            break;
        case 1: {
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                
            });
        }
            break;
        case 2: {
            tips = @"上下图文";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert([UIImage imageNamed:@"sample2"], 0, CGPointZero, CGSizeMake(50, 50));
                make.insert(@"\n  上下图文  ", -1).alignment(NSTextAlignmentCenter).lineSpacing(8);
                [self updateConstraintsWithSize:make.size()];
            });
        }
            break;
        case 3: {
            tips = @"左右图文";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"  左右图文  ", 0);
                make.font([UIFont boldSystemFontOfSize:18]).textColor([UIColor redColor]);
                make.insert([UIImage imageNamed:@"sample2"], 0, CGPointMake(0, -18), CGSizeMake(50, 50));
                [self updateConstraintsWithSize:make.size()];
            });
        }
            break;
        case 4: {
            tips = @"左缩进 + 右缩进";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"故事:", 0);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont boldSystemFontOfSize:22]);
                    lastOperator.textColor([UIColor yellowColor]);
                });
                
                CGSize lastSize = make.size();
                make.insert(@"叶秋笑了笑，抬手取下了衔在嘴角的烟头。银白的烟灰已经结成了长长一串，但在叶秋挥舞着鼠标敲打着键盘施展操作的过程中却没有被震落分毫。摘下的烟头很快被掐灭在了桌上的一个形状古怪的烟灰缸里，叶秋的手飞快地回到了键盘，正准备对对手说点什么，房门却突得咣一声被人打开了。", -1);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont systemFontOfSize:14]);
                    lastOperator.textColor([UIColor blueColor]);
                });

                // 左缩进
                make.headIndent(lastSize.width);
                // 右缩进
                make.tailIndent(-12);
                
                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
            });
        }
            break;
        case 5: {
            tips = @"下划线 + 删除线";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"下划线", 0);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont boldSystemFontOfSize:40]).underLine([SJUnderlineAttribute underLineWithStyle:NSUnderlineStyleSingle | NSUnderlinePatternSolid color:[UIColor orangeColor]]);
                });
                
                make.insert(@"删除线", -1);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont boldSystemFontOfSize:40]).strikethrough([SJUnderlineAttribute underLineWithStyle:NSUnderlineStyleSingle | NSUnderlinePatternSolid color:[UIColor orangeColor]]);
                });
                
                [self updateConstraintsWithSize:make.size()];
            });
        }
            break;
    }
    
    
    if ( !attr ) return;
    _tipsLabel.text = tips;
    _testLabel.attributedText = attr;
    
    NSLog(@"------------- end -------------");
}

- (void)updateConstraintsWithSize:(CGSize)size {
    _widthConstraint.constant = size.width;
    _heightConstraint.constant = size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
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

