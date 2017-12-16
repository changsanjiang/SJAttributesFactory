//
//  SJTableViewCell.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/15.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJTableViewCell.h"

@interface SJTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation SJTableViewCell
@synthesize label = _label;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) return nil;
    [self _cellSetupView];
    return self;
}

- (void)updateHeight {
    if ( _label.height == _heightConstraint.constant ) return;
    _heightConstraint.constant = _label.height;
}

- (void)_cellSetupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.label];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    _label.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                       green:1.0 * (arc4random() % 256 / 255.0)
                                                        blue:1.0 * (arc4random() % 256 / 255.0)
                                                       alpha:1];
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    _heightConstraint.priority = UILayoutPriorityRequired;
    [_label addConstraint:_heightConstraint];
}

- (SJLabel *)label {
    if ( _label ) return _label;
    _label = [[SJLabel alloc] initWithText:nil font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] lineSpacing:8];
    _label.backgroundColor = [UIColor whiteColor];
    return _label;
}
@end
