//
//  SJTableViewCell.m
//  SJAttributesFactory
//
//  Created by BlueDancer on 2017/12/15.
//  Copyright © 2017年 畅三江. All rights reserved.
//

#import "SJTableViewCell.h"

@interface SJTableViewCell ()

@end

@implementation SJTableViewCell
@synthesize label = _label;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) return nil;
    [self _cellSetupView];
    return self;
}

- (void)_cellSetupView {
    [self.contentView addSubview:self.label];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
}

- (SJLabel *)label {
    if ( _label ) return _label;
    _label = [[SJLabel alloc] initWithText:nil font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] lineSpacing:8];
    _label.backgroundColor = [UIColor whiteColor];
    return _label;
}
@end
