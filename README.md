# SJAttributesFactory    

### Use
```ruby
pod 'SJAttributesFactory'
```

### Example

<img src="https://github.com/changsanjiang/SJAttributesFactory/blob/master/SJAttributesFactory/sample1.png" />    


```Objective-C
    NSString *webAddress = @"webAddress:http://www.baidu.com\n";
    NSString *phone = @"phone:12345678901\n";
    NSString *name = @"name:SanJiang\n";
    _testBtn.titleLabel.numberOfLines = 0;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@", webAddress, phone, name];
    NSAttributedString *attr = [SJAttributesFactory alterStr:str block:^(SJAttributesFactory *alter) {
        // 修改整体
        alter
        .font([UIFont systemFontOfSize:20])
        .backgroundColor([UIColor grayColor])
        .lineSpacing(25)
        .alignment(NSTextAlignmentRight)
        .insertImage([UIImage imageNamed:@"sample"], CGSizeMake(20, 20), 10);
        
        UIColor *color = [UIColor greenColor];
        NSRange range = NSMakeRange(webAddress.length, phone.length);
        // 修改指定范围
        alter.nextFont([UIFont boldSystemFontOfSize:20]).nextFontColor(color).range(range);
        
        alter
        .nextFontColor([UIColor blueColor])
        .nextUnderline([UIColor cyanColor])
        .nextBackgroundColor([UIColor orangeColor])
        .nextStrikethough([UIColor brownColor])
        .nextStroke(-1, [UIColor blackColor])
        .nextLetterSpacing(2)
        .nextLetterpress()
        .range(NSMakeRange(0, webAddress.length));
    }];
    
    [_testBtn setAttributedTitle:attr forState:UIControlStateNormal];
```
