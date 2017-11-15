//
//  ViewController.m
//  SJAttributesFactory
//
//  Created by 畅三江 on 2017/11/6.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "ViewController.h"
#import "SJAttributesFactory.h"
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
            tips = @"左右图文";
            attr = [SJAttributesFactory alteringStr:@"9999\n9999999" task:^(SJAttributeWorker * _Nonnull worker) {
                
                worker
                .insert([UIImage imageNamed:@"sample2"], 0, CGPointMake(0, -20), CGSizeMake(50, 50))
                .font([UIFont boldSystemFontOfSize:14])
                .fontColor([UIColor whiteColor]);
                
                CGSize size = worker.size(NSMakeRange(0, worker.length));
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 1: {
            tips = @"上下图文";
            attr = [SJAttributesFactory producingWithTask:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .insert(@"9999\n999\n999", 0)
                .insert(@"\n", 0)
                .insert([UIImage imageNamed:@"sample2"], 0, CGPointZero, CGSizeMake(50, 50))
                .lineSpacing(8)
                .alignment(NSTextAlignmentCenter)
                .font([UIFont boldSystemFontOfSize:14])
                .fontColor([UIColor whiteColor]);
                
                CGSize size = worker.size(NSMakeRange(0, worker.length));
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 2: {
            tips = @"头缩进 + 尾缩进";
            attr = [SJAttributesFactory alteringStr:@"故事:可以解释为旧事、旧业、先例、典故等涵义,同时,也是文学体裁的一种,侧重于事情过程的描述,强调情节跌宕起伏,从而阐发道理或者价值观." task:^(SJAttributeWorker * _Nonnull worker) {
                
                worker.font([UIFont systemFontOfSize:14]);
                
                // 获取开头宽度
                CGFloat startW = worker.width(NSMakeRange(0, 3));
                
                worker
                .firstLineHeadIndent(8) // 首行缩进
                .headIndent(startW + 8) // 左缩进
                .tailIndent(-12);       // 右缩进
                

                worker.nextFont([UIFont boldSystemFontOfSize:14]).range(NSMakeRange(0, 3));
                
                CGSize size = worker.boundsByMaxWidth(self.view.frame.size.width * 0.8).size;
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 3: {
            tips = @"字体放大";
            attr = [SJAttributesFactory alteringStr:@"我的故乡\n我的故乡" task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:40])
                .alignment(NSTextAlignmentCenter);
                
                worker.nextExpansion(1).range(NSMakeRange(0, 4));
                
                CGSize size = worker.size(NSMakeRange(0, worker.length));
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 4: {
            tips = @"下划线 + 删除线";
            attr = [SJAttributesFactory alteringStr:@"$ 999" task:^(SJAttributeWorker * _Nonnull worker) {
                worker.font([UIFont systemFontOfSize:40]);
                worker.underline(NSUnderlineByWord | NSUnderlinePatternSolid | NSUnderlineStyleDouble, [UIColor yellowColor]).strikethrough(NSUnderlineByWord | NSUnderlinePatternSolid | NSUnderlineStyleDouble, [UIColor redColor]);
                
                CGSize size = worker.size(NSMakeRange(0, worker.length));
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 5: {
            tips = @"局部段落样式";
            NSString *pre = @"采薇采薇,薇亦作止.\n";
            NSString *mid = @"曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.\n";
            NSString *end = @"曰归曰归,岁亦莫止.靡家靡室,猃狁之故.不遑启居,猃狁之故.";
            attr = [SJAttributesFactory alteringStr:[NSString stringWithFormat:@"%@%@%@", pre, mid, end] task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .alignment(NSTextAlignmentCenter)
                .font([UIFont boldSystemFontOfSize:16])
                .fontColor([UIColor orangeColor]);
                
                worker
                .nextFont([UIFont boldSystemFontOfSize:12])
                .nextFontColor([UIColor yellowColor])
                .nextParagraphSpacingBefore(8)
                .nextLineSpacing(8)
                .nextFirstLineHeadIndent(8)
                .nextHeadIndent(40)
                .nextTailIndent(-40)
                .nextAlignment(NSTextAlignmentRight)
                .range(NSMakeRange(pre.length, mid.length));
                
                worker
                .nextFontColor([UIColor blueColor])
                .range(NSMakeRange(pre.length, 2));

                CGSize size = worker.boundsByMaxWidth(self.view.bounds.size.width * 0.8).size;
                [self updateConstraintsWithSize:size];
            }];
        }
            break;
        case 6: {
            tips = @"凸版 + 倾斜";
            attr = [SJAttributesFactory alteringStr:@"我的故乡\n我的故乡" task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:40])
                .letterpress()
                .obliqueness(0.2);
            }];
        }
            break;
        case 7: {
            tips = @"指定位置插入文本";
            attr = [SJAttributesFactory alteringStr:@"我的故乡" task:^(SJAttributeWorker * _Nonnull worker) {
                NSLog(@"插入前: %zd", worker.length);
                
                worker
                .font([UIFont systemFontOfSize:20])
                .insertText(@", 在哪里?", 4);
                
                NSLog(@"插入后: %zd", worker.length);
            }];
        }
            break;
        case 8: {
            tips = @"指定范围删除文本";
            attr = [SJAttributesFactory alteringStr:@"我的故乡" task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:20])
                .removeText(NSMakeRange(0, 2));
            }];
        }
            break;
        case 9: {
            tips = @"清除";
            attr = _testLabel.attributedText;
            attr = [SJAttributesFactory alteringAttrStr:attr task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:20])
                .clean();
            }];
        }
            break;
        case 10: {
            tips = @"段前间隔 and 段后间隔";
            attr = [SJAttributesFactory alteringStr:@"谁谓河广？一苇杭之.谁谓宋远？跂予望之.\n 谁谓河广？曾不容刀.\n 谁谓宋远？曾不崇朝.\n" task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:20])
                .paragraphSpacingBefore(10)
                .paragraphSpacing(10);
            }];
        }
            break;
        case 11: {
            tips = @"效果同上";
            attr = [SJAttributesFactory alteringStr:@"谁谓河广？一苇杭之.谁谓宋远？跂予望之.谁谓河广？曾不容刀.\n 谁谓宋远？曾不崇朝.\n" task:^(SJAttributeWorker * _Nonnull worker) {
                worker
                .font([UIFont systemFontOfSize:20])
                .paragraphSpacing(20);
            }];
        }
            break;
        case 12: {
            tips = @"字体阴影";
            attr = [SJAttributesFactory alteringStr:@"我的故乡" task:^(SJAttributeWorker * _Nonnull worker) {
                NSShadow *shadow = [NSShadow new];
                shadow.shadowColor = [UIColor greenColor];
                shadow.shadowOffset = CGSizeMake(1, 1);
                
                worker
                .font([UIFont boldSystemFontOfSize:40])
                .shadow(shadow);
            }];    
        }
            break;
        case 13: {
            tips = @"Altering Range Sample";
            attr = [SJAttributesFactory alteringStr:@"I am a bad man!" task:^(SJAttributeWorker * _Nonnull worker) {
                worker.font([UIFont boldSystemFontOfSize:18]);
                
                // 修改 I
                worker.rangeEdit(NSMakeRange(0, 1), ^(SJAttributeWorker * _Nonnull range) {
                    range
                    .nextFont([UIFont boldSystemFontOfSize:30])
                    .nextFontColor([UIColor orangeColor]);
                });
                
                // 修改 bad
                worker.rangeEdit(NSMakeRange(7, 3), ^(SJAttributeWorker * _Nonnull range) {
                   range
                    .nextFont([UIFont boldSystemFontOfSize:30])
                    .nextFontColor([UIColor purpleColor])
                    .nextObliqueness(0.3);
                });
                
                CGSize size = worker.boundsByMaxWidth(self.view.bounds.size.width * 0.8).size;
                [self updateConstraintsWithSize:size];

            }];
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

