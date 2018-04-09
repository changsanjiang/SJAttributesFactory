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
    self.testLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.testLabel.layer.borderWidth = 0.6;
    self.testLabel.clipsToBounds = YES;
    self.testLabel.backgroundColor = [UIColor whiteColor];
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
            tips = @"常用方法";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"叶秋笑了笑，抬手取下了衔在嘴角的烟头。", 0);
                
                make
                .font([UIFont boldSystemFontOfSize:40])                       // 设置字体
                .textColor([UIColor blackColor])                              // 设置文本颜色
                .underLine(NSUnderlineStyleSingle, [UIColor orangeColor])     // 设置下划线
                .strikethrough(NSUnderlineStyleSingle, [UIColor orangeColor]) // 设置删除线
//                .shadow(CGSizeMake(0.5, 0.5), 0, [UIColor redColor])        // 设置阴影
//                .backgroundColor([UIColor whiteColor])                      // 设置文本背景颜色
                .stroke([UIColor greenColor], 1)                              // 字体边缘的颜色, 设置后, 字体会镂空
//                .offset(-10)                                                // 上下偏移
                .obliqueness(0.3)                                             //  倾斜
                .letterSpacing(4)                                             // 字体间隔
                .lineSpacing(4)                                               // 行间隔
                .alignment(NSTextAlignmentCenter)                             // 对其方式
                ;
                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
            });
        }
            break;
        case 1: {
            tips = @"正则匹配";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.insert(@"@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#", 0);

                // 匹配 以@字符开头, 后接一个以上非空格字符, 直到遇到一个空格字符
                make.regexp(@"[@][^\\s]+\\s", ^(SJAttributesRangeOperator * _Nonnull matched) {
                    matched.textColor([UIColor purpleColor]);
                });
                
                // 匹配 以#字符开头, 后接一个以上非#字符, 直到遇到一个#字符
                make.regexp(@"[#][^#]+#", ^(SJAttributesRangeOperator * _Nonnull matched) {
                    matched.textColor([UIColor orangeColor]);
                });
                
                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
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
                
                // 编辑最近一次插入的文本
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont boldSystemFontOfSize:22]);
                    lastOperator.textColor([UIColor yellowColor]);
                });
                
                CGSize lastSize = make.size();
                make.insert(@"叶秋笑了笑，抬手取下了衔在嘴角的烟头。银白的烟灰已经结成了长长一串，但在叶秋挥舞着鼠标敲打着键盘施展操作的过程中却没有被震落分毫。摘下的烟头很快被掐灭在了桌上的一个形状古怪的烟灰缸里，叶秋的手飞快地回到了键盘，正准备对对手说点什么，房门却突得咣一声被人打开了。", -1);
                // 编辑最近一次插入的文本
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
                    lastOperator.font([UIFont boldSystemFontOfSize:40]).underLine(NSUnderlineStyleSingle, [UIColor orangeColor]);
                });
                
                make.insert(@"删除线", -1);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.font([UIFont boldSystemFontOfSize:40]).strikethrough(NSUnderlineStyleSingle | NSUnderlinePatternDot, [UIColor orangeColor]);
                });
                
                [self updateConstraintsWithSize:make.size()];
            });
        }
            break;
        case 6: {
            tips = @"替换文本";
            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
                make.font([UIFont boldSystemFontOfSize:14]).textColor([UIColor orangeColor]);
                make.insert(@"叶秋笑了笑笑笑笑笑笑,", 0);
               
                make.insert(@"抬手取下了", -1);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.textColor([UIColor greenColor]);
                });
                
                make.insert(@"衔在嘴角的烟头H.", -1);
                make.lastInserted(^(SJAttributesRangeOperator * _Nonnull lastOperator) {
                    lastOperator.textColor([UIColor redColor]);
                    lastOperator.font([UIFont boldSystemFontOfSize:17]);
                });
                
                make.regexp_r(@"H", ^(NSArray<NSValue *> * _Nonnull matchedRanges) {
                    [matchedRanges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSRange matchedRange = [obj rangeValue];

                        make.replace(matchedRange, @"h");
                        make.insert(@"ello", matchedRange.location + matchedRange.length); // h + ello == hello
                    }];
                }, YES);
                
                
                make.regexp_insert(@"嘴角", SJAttributeRegexpInsertPositionRight, [UIImage imageNamed:@"sample2"], 0, CGPointMake(0, 0), CGSizeZero);
                
                make.regexp_replace(@"笑", [UIImage imageNamed:@"sample2"], CGPointZero, CGSizeZero);


                
                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
            });
        }
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

