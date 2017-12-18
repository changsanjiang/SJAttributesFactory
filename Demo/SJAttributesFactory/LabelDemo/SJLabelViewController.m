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

@end

@implementation SJLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:NSClassFromString(SJTableViewCellID) forCellReuseIdentifier:SJTableViewCellID];
    self.tableView.estimatedRowHeight = 150;
    
    _content = @"👌👌👌我被班主任杨老师叫到办公室，当时上课铃刚响，杨老师过来找我，我挺奇怪的，什么事啊，可以连课都不上？当时办公室里就我们两个人。杨老师拿出手机，让我看她拍的一张照片，是我们班最近一次班级活动时照的。我们仨坐在一张椅子上，我坐在中间，皱着个眉头，😁小喵托着腮帮子，小桐则靠着椅背坐着。";
    
    NSLog(@"%zd", _content.length);

//    _label = [[SJLabel alloc] initWithText:nil font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor] lineSpacing:0 userInteractionEnabled:YES];
//    _label.numberOfLines = 0;
//    __weak typeof(self) _self = self;
//    _label.attributedText = [SJAttributesFactory producingWithTask:^(SJAttributeWorker * _Nonnull worker) {
//        worker.insertText(_content, 0);
//        worker.font([UIFont boldSystemFontOfSize:22]);
//        worker.lineSpacing(8);
//
//        worker.regexp(@"我", ^(SJAttributeWorker * _Nonnull regexp) {
//            regexp.nextFontColor([UIColor yellowColor]);
//            regexp.nextUnderline(NSUnderlineStyleSingle, [UIColor yellowColor]);
//
//            regexp.nextAction(^{
//                NSLog(@"`我` 被点击了");
//                __strong typeof(_self) self = _self;
//                if ( !self ) return;
//                UIViewController *vc = [UIViewController new];
//                vc.title = @"我";
//                vc.view.backgroundColor = [UIColor greenColor];
//                [self.navigationController pushViewController:vc animated:YES];
//            });
//        });
//
//        worker.regexp(@"杨老师", ^(SJAttributeWorker * _Nonnull regexp) {
//            regexp.nextFontColor([UIColor redColor]);
//
//            regexp.next(SJActionAttributeName, ^() {
//                NSLog(@"`杨老师` 被点击了");
//                __strong typeof(_self) self = _self;
//                if ( !self ) return;
//                UIViewController *vc = [UIViewController new];
//                vc.title = @"杨老师";
//                vc.view.backgroundColor = [UIColor greenColor];
//                [self.navigationController pushViewController:vc animated:YES];
//            });
//        });
//
//        worker.insertImage([UIImage imageNamed:@"sample2"], 10, CGPointZero, CGSizeMake(20, 20));
//        worker.insertImage([UIImage imageNamed:@"sample2"], 15, CGPointZero, CGSizeMake(20, 20));
//        worker.insertImage([UIImage imageNamed:@"sample2"], 20, CGPointZero, CGSizeMake(20, 20));
//        worker.insertImage([UIImage imageNamed:@"sample2"], 25, CGPointZero, CGSizeMake(20, 20));
//    }];
//    _label.backgroundColor = [UIColor greenColor];
//    _label.userInteractionEnabled = YES;
//    [self.view addSubview:_label];
//    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.offset(0);
//        make.width.equalTo(self.view).multipliedBy(0.8);
//    }];
//
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
//
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//
//    _tLabel = [UILabel new];
//    _tLabel.font = [UIFont systemFontOfSize:14];
//    _tLabel.textColor = [UIColor blueColor];
//    _tLabel.backgroundColor = [UIColor greenColor];
//    _tLabel.text = _content;
//    _tLabel.numberOfLines = 0;
//    [self.view addSubview:_tLabel];
//    [_tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_label.mas_bottom).offset(8);
//        make.centerX.offset(0);
//        make.width.equalTo(self.view).multipliedBy(0.8);
//        make.height.offset(ceil((ABS(_tLabel.font.descender) + _tLabel.font.ascender + _tLabel.font.leading)) * 7);
//    }];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTableViewCell *cell = (SJTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SJTableViewCellID forIndexPath:indexPath];
    __weak typeof(self) _self = self;
    cell.label.attributedText = [SJAttributesFactory producingWithTask:^(SJAttributeWorker * _Nonnull worker) {
        worker.insertText(_content, 0);
        worker.font([UIFont boldSystemFontOfSize:22]);
        worker.lineSpacing(8);
        
        worker.regexp(@"我们", ^(SJAttributeWorker * _Nonnull regexp) {
            regexp.nextFontColor([UIColor yellowColor]);
            regexp.nextUnderline(NSUnderlineStyleSingle, [UIColor yellowColor]);
            
            regexp.nextAction(^(NSRange range, NSAttributedString * _Nonnull matched) {
                NSLog(@"`%@` 被点击了", matched.string);
                __strong typeof(_self) self = _self;
                if ( !self ) return;
                UIViewController *vc = [UIViewController new];
                vc.title = matched.string;
                vc.view.backgroundColor = [UIColor greenColor];
                [self.navigationController pushViewController:vc animated:YES];

            });
        });
        
        worker.regexp(@"杨老师", ^(SJAttributeWorker * _Nonnull regexp) {
            regexp.nextFontColor([UIColor redColor]);
            
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
        
        worker.insertImage([UIImage imageNamed:@"sample2"], 10, CGPointZero, CGSizeMake(20, 20));
        worker.insertImage([UIImage imageNamed:@"sample2"], 15, CGPointZero, CGSizeMake(20, 20));
        worker.insertImage([UIImage imageNamed:@"sample2"], 20, CGPointZero, CGSizeMake(20, 20));
        worker.insertImage([UIImage imageNamed:@"sample2"], 25, CGPointZero, CGSizeMake(20, 20));
    }];;
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
