//
//  SJLabelViewController.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/14.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJLabelViewController.h"
#import "SJTableViewCell.h"
#import <Masonry.h>
#import "SJAttributesFactoryHeader.h"

static NSString *SJTableViewCellID = @"SJTableViewCell";

@interface SJLabelViewController ()

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) SJLabel *label;

@property (nonatomic, strong) UILabel *tLabel;

@property (nonatomic, strong) NSAttributedString *attrStr;

@end

@implementation SJLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:NSClassFromString(SJTableViewCellID) forCellReuseIdentifier:SJTableViewCellID];
    self.tableView.estimatedRowHeight = 150;
    
    _content = @"👌👌👌我被班主任杨老师叫到办公室，当时上课铃刚响，杨老师过来找我，我挺奇怪的，什么事啊，可以连课都不上？当时办公室里就我们两个人。杨老师拿出手机，让我看她拍的一张照片，是我们班最近一次班级活动时照的。我们仨坐在一张椅子上，我坐在中间，皱着个眉头，😁小喵托着腮帮子，小桐则靠着椅背坐着。";
    
    NSLog(@"%zd", _content.length);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __weak typeof(self) _self = self;
        
        _attrStr = [SJAttributesFactory producingWithTask:^(SJAttributeWorker * _Nonnull worker) {
            worker.insertText(_content, 0);
            worker.font([UIFont boldSystemFontOfSize:22]);
            worker.lineSpacing(8);
            worker
            .insertImage([UIImage imageNamed:@"sample2"], 10, CGPointZero, CGSizeMake(20, 20))
            .insertImage([UIImage imageNamed:@"sample2"], 15, CGPointZero, CGSizeMake(20, 20))
            .insertImage([UIImage imageNamed:@"sample2"], 20, CGPointZero, CGSizeMake(20, 20))
            .insertImage([UIImage imageNamed:@"sample2"], 25, CGPointZero, CGSizeMake(20, 20));

            
            worker.regexp(@"我们", ^(SJAttributeWorker * _Nonnull regexp) {
                regexp.nextFontColor([UIColor yellowColor]);
                regexp.nextUnderline(NSUnderlineStyleSingle, [UIColor yellowColor]);

                // action 1
                regexp.nextAction(^(NSRange range, NSAttributedString * _Nonnull matched) {
                    NSLog(@"`%@` 被点击了", matched.string);
                });
            });
            
            worker.regexp(@"杨老师", ^(SJAttributeWorker * _Nonnull regexp) {
                regexp.nextFontColor([UIColor redColor]);
                
                // action 2
                regexp.next(SJActionAttributeName, ^(NSRange range, NSAttributedString *str) {
                    NSLog(@"`%@` 被点击了", str.string);
                    __strong typeof(_self) self = _self;
                    if ( !self ) return;
                    UIViewController *vc = [UIViewController new];
                    vc.title = str.string;
                    vc.view.backgroundColor = [UIColor greenColor];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            });
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%zd", _attrStr.length);
            [self.tableView reloadData];
        });

    });
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _attrStr ) return 1;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTableViewCell *cell = (SJTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SJTableViewCellID forIndexPath:indexPath];
    cell.label.attributedText = _attrStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SJTableViewCell *cell = (SJTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.label.numberOfLines = 0;
//    cell.label.textAlignment = NSTextAlignmentRight;
//    _label.numberOfLines = 3;
//    _label.text = _content;

//    [UIView animateWithDuration:0.25 animations:^{
//       [self.view layoutIfNeeded];
//    }];
}

@end
