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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"");
    });
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
            attr = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.font([UIFont boldSystemFontOfSize:20]);
                make.lineSpacing(8);
                make.append(@"叶秋笑了笑，抬手取下了衔在嘴角的烟头。");
                make.underLine(^(id<SJUTDecoration>  _Nonnull make) {
                    make.style = NSUnderlineStyleSingle;
                    make.color = [UIColor orangeColor];
                });
                make.strikethrough(^(id<SJUTDecoration>  _Nonnull make) {
                    make.style = NSUnderlineStyleSingle;
                    make.color = [UIColor orangeColor];
                });
                
                make.regex(@"叶秋").update(^(id<SJUTAttributesProtocol>  _Nonnull make) {
                    make.font([UIFont boldSystemFontOfSize:40]).textColor([UIColor purpleColor]);
                });
                
                make.regex(@"笑了笑").replaceWithText(^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                    make.append(@"xiao了笑");
                });
                
                make.regex(@"抬手").replaceWithString(@"Tai手");
            }];
        }
            break;
        case 1: {
            tips = @"正则匹配";
            attr = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.font([UIFont boldSystemFontOfSize:20]);
                make.append(@"@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#");
                
                make.regex(@"[@][^\\s]+\\s").update(^(id<SJUTAttributesProtocol>  _Nonnull make) {
                    make.textColor([UIColor purpleColor]);
                });
                
                make.regex(@"[#][^#]+#").update(^(id<SJUTAttributesProtocol>  _Nonnull make) {
                    make.textColor([UIColor orangeColor]);
                });
            }];

        }
            break;
        case 2: {
            tips = @"上下图文";
            attr = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.appendImage(^(id<SJUTImageAttachment>  _Nonnull make) {
                    make.image = [UIImage imageNamed:@"sample2"];
                    make.bounds = CGRectMake(0, 0, 50, 50);
                });
                make.append(@"\n上下图文");
                make.alignment(NSTextAlignmentCenter).lineSpacing(8);
            }];
        }
            break;
        case 3: {
            tips = @"左右图文";
            attr = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(@"  左右图文  ");
                make.font([UIFont boldSystemFontOfSize:18]).textColor([UIColor redColor]);
                make.appendImage(^(id<SJUTImageAttachment>  _Nonnull make) {
                    make.image = [UIImage imageNamed:@"sample2"];
                    make.bounds = CGRectMake(0, -18, 50, 50);
                });
            }];
        }
            break;
//        case 8: {
//            tips = @"测试";
//
//            attr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
////                大写 P 表示 Unicode 字符集七个字符属性之一：标点字符
////                L：字母；
////                M：标记符号（一般不会单独出现）；
////                Z：分隔符（比如空格、换行等）；
////                S：符号（比如数学符号、货币符号等）；
////                N：数字（比如阿拉伯数字、罗马数字等）；
////                C：其他字符
//
//                make.append(@"&&&&###@@$$$$");
//
//                make.regexp(@"^[\\p{S}|\\p{P}|\\p{M}|\\p{Z}]+$", ^(SJAttributesRangeOperator * _Nonnull make) {
//                    make.textColor([UIColor redColor]);
//                });
//
//                [self updateConstraintsWithSize:make.sizeByWidth(self.view.bounds.size.width - 80)];
//            });
//        }
//            break;
    }
    
    
    if ( !attr ) return;
    _tipsLabel.text = tips;
    _testLabel.attributedText = attr;
    [self updateConstraints];
    
    NSLog(@"------------- end -------------");
}

- (void)updateConstraints {
    CGSize size = sj_textSize(_testLabel.attributedText, self.view.bounds.size.width - 80, CGFLOAT_MAX);
    _widthConstraint.constant = size.width;
    _heightConstraint.constant = size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

static CGSize sj_textSize(NSAttributedString *attrStr, CGFloat width, CGFloat height) {
    if ( attrStr.length < 1 )
        return CGSizeZero;
    CGRect bounds = [attrStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    bounds.size.width = ceil(bounds.size.width);
    bounds.size.height = ceil(bounds.size.height);
    return bounds.size;
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

