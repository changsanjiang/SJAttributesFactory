# SJAttributesFactory

### Use
```ruby
pod 'SJAttributesFactory'
```

### Example

<img src="https://github.com/changsanjiang/SJAttributesFactory/blob/master/SJAttributesFactory/ex.gif" />


```Objective-C
switch (indexPath.row) {
case 0: {
tips = @"左右图文";
attr = [SJAttributesFactory alterStr:@"9999" block:^(SJAttributesFactory * _Nonnull worker) {
worker
.insertImage([UIImage imageNamed:@"sample2"], CGSizeMake(50, 50), 0)
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
.insertImage([UIImage imageNamed:@"sample2"], CGSizeMake(50, 50), 0)
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
worker.insertText(@", 在哪里?", 4);
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
}
```
