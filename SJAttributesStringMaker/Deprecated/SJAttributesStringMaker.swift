//
//  SJAttributesStringMaker.swift
//  SwiftTest
//
//  Created by BlueDancer on 2018/1/25.
//  Copyright © 2018年 SanJiang. All rights reserved.
//
//  Project: https://github.com/changsanjiang/SJAttributesFactory
//  Email:  changsanjiang@gmail.com
//

import UIKit


public func sj_makeAttributesString(_ task: ((SJAttributesStringMaker) -> Void)) -> NSMutableAttributedString {
    let maker = SJAttributesStringMaker.init()
    task(maker)
    return maker.endTask()
}


public class SJAttributesRangeOperator {
    
    fileprivate var recorder: SJAttributesRecorder = SJAttributesRecorder()
}

public class SJAttributesStringMaker: SJAttributesRangeOperator {
    
    fileprivate let attrStr: NSMutableAttributedString = NSMutableAttributedString()
    
    private var rangeOperatorsM: [SJAttributesRangeOperator] = [SJAttributesRangeOperator]()
    
    /// default is UIFont.systemFont(ofSize: 14)
    var defaultFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    /// default is UIColor.black
    var defaultTextColor: UIColor = UIColor.black
    
    public var workInProcess: NSMutableAttributedString {
        get {
            return self.attrStr
        }
    }
    
    public var length: Int {
        get { return self.attrStr.length}
    }
    
    public var range: NSRange {
        get {
            return NSRange.init(location: 0, length: self.attrStr.length)
        }
    }
    
    @discardableResult
    private func pauseTask() -> NSMutableAttributedString {
        return self.endTask()
    }
    
    public func endTask() -> NSMutableAttributedString {
        if 0 == self.attrStr.length {
            return self.attrStr
        }
        
        if ( nil == self.recorder.font ) {
            self.recorder.font = self.defaultFont
        }
        
        if ( nil == self.recorder.textColor ) {
            self.recorder.textColor = self.defaultTextColor
        }
        
        self.recorder.addAttributes(self.attrStr)
        for rangeOperator in self.rangeOperatorsM {
            rangeOperator.recorder.addAttributes(self.attrStr)
        }
        return attrStr
    }
    
    public func subAttrStr(_ byRange: NSRange) -> NSAttributedString? {
        if ( !_rangeContains(self.range, byRange) ) {
            _errorLog("Get AttrStr Failed! param 'range' is unlawful!", self.attrStr.string);
            return nil
        }
        
        self.pauseTask()
        return self.attrStr.attributedSubstring(from:byRange)
    }
    
    /// 指定范围进行编辑
    @discardableResult
    func rangeEdit(_ range: NSRange, _ rangeTask: (SJAttributesRangeOperator) -> Void) -> SJAttributesStringMaker {
        let attrRangeOperator = _getRangeOperator(range)
        rangeTask(attrRangeOperator)
        return self
    }
    
    private func _getRangeOperator(_ range: NSRange) -> SJAttributesRangeOperator {
        var rangeOperator: SJAttributesRangeOperator?
        for obj in self.rangeOperatorsM {
            let objRange = obj.recorder.range!
            if ( objRange.location == range.location && objRange.length == range.length ) {
                rangeOperator = obj;
                break;
            }
        }
        
        if ( nil != rangeOperator ) {
            return rangeOperator!
        }
        
        for obj in self.rangeOperatorsM {
            let objRange = obj.recorder.range!
            if ( _rangeContains(objRange, range) ) {
                rangeOperator = SJAttributesRangeOperator.init();
                rangeOperator!.recorder = obj.recorder.copy() as! SJAttributesRecorder
                rangeOperator!.recorder.range = range
                self.rangeOperatorsM.append(rangeOperator!)
                break;
            }
        }
        
        if ( nil != rangeOperator ) {
            return rangeOperator!;
        }
        
        
        rangeOperator = SJAttributesRangeOperator.init();
        rangeOperator!.recorder.range = range
        self.rangeOperatorsM.append(rangeOperator!)
        return rangeOperator!
    }
}


// MARK: 正则 - regexp

public extension SJAttributesStringMaker {
    
    /// 正则匹配
    func regexp(_ regexpStr: String, matchedTask: ((SJAttributesRangeOperator) -> Void)) -> Void {
        regexp(regexpStr, reversed: true, matchedRanges: { (matchedRangesArr) in
            for matched in matchedRangesArr {
                rangeEdit(matched, matchedTask)
            }
        })
    }
    
    /// 正则匹配
    func regexp(_ regexpStr: String, reversed: Bool? = nil, matchedRanges: (([NSRange]) -> Void) ) -> Void {
        
        if ( regexpStr.isEmpty ) {
            _errorLog("Exe Regular Expression Failed! param `ex` is empty!", self.attrStr.string);
            return
        }
        
        let regularEx = try? NSRegularExpression.init(pattern: regexpStr, options: NSRegularExpression.Options(rawValue: 0))
        if nil == regularEx {
            return
        }
        
        var matchedRangesArrM = [NSRange]()
        regularEx!.enumerateMatches(in: self.attrStr.string, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: self.range) { (result, flags, stop) in
            if nil != result {
                matchedRangesArrM.append(result!.range)
            }
        }
        if reversed == true {
            matchedRangesArrM = matchedRangesArrM.reversed()
        }
        matchedRanges(matchedRangesArrM)
    }
}


// MARK: 大小 - size

public extension SJAttributesStringMaker {
    
    func size() -> CGSize {
        return self.bounds(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude, range: self.range).size
    }
    
    func size(byRange: NSRange) -> CGSize {
        return self.bounds(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude, range: byRange).size
    }
    
    func size(byMaxWidth: CGFloat) -> CGSize {
        return self.bounds(width: byMaxWidth, height: CGFloat.greatestFiniteMagnitude, range: self.range).size
    }
    
    func size(byMaxHeight: CGFloat) -> CGSize {
        return self.bounds(width: CGFloat.greatestFiniteMagnitude, height: byMaxHeight, range: self.range).size
    }
    
    private func bounds(width: CGFloat, height: CGFloat, range: NSRange) -> CGRect {
        var r = range
        if ( (range.location == 0 && range.length == 0) || !_rangeContains(self.range, range) ) {
            r = self.range
        }
        self.pauseTask()
        let attrSrr = self.subAttrStr(r)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue
        let bounds = attrSrr!.boundingRect(with: CGSize.init(width: width, height: height), options:NSStringDrawingOptions(rawValue: options), context: nil)
        return CGRect.init(x: 0, y: 0, width: ceil(bounds.size.width), height: ceil(bounds.size.height))
    }
}


// MARK: 插入 - insert

public extension SJAttributesStringMaker {
    
    /// 添加属性
    @discardableResult
    func add(key: NSAttributedString.Key, value: Any, range: NSRange) -> SJAttributesStringMaker {
        self.attrStr.addAttribute(key, value: value, range: range)
        return self
    }
    
    /// 插入文本
    @discardableResult
    func insertText(_ text: String, _ index: Int) -> SJAttributesRangeOperator {
        return self.insertAttrStr(NSAttributedString.init(string: text), index)
    }
    
    /// 插入图片
    @discardableResult
    func insertImage(_ image: UIImage, _ index: Int, _ offset: CGPoint, _ size: CGSize) -> SJAttributesRangeOperator {
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = CGRect.init(origin: offset, size: size)
        return self.insertAttrStr(NSAttributedString.init(attachment: attachment), index)
    }
    
    /// 插入文本
    @discardableResult
    func insertAttrStr(_ text: NSAttributedString, _ index: Int) -> SJAttributesRangeOperator {
        if 0 == text.length {
            return self
        }
        
        var idx = index
        if -1 == idx || self.attrStr.length > idx {
            idx = self.attrStr.length
        }
        self.lastInsertedRange = NSRange.init(location: idx, length: text.length)
        self.attrStr.insert(text, at: idx)
        return self
    }
    
    /// 最后一次插入的文本位置
    var lastInsertedRange: NSRange? {
        get {
            return objc_getAssociatedObject(self, &kLastInsertedRange) as? NSRange
        }
        set {
            objc_setAssociatedObject(self, &kLastInsertedRange, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 编辑最后一次插入的文本
    func lastInserted(_ task:((SJAttributesRangeOperator) -> Void)) -> Void {
        if nil == self.lastInsertedRange {
            return
        }
        self.rangeEdit(self.lastInsertedRange!, task)
    }
}


// MARK: 替换 - replace

public extension SJAttributesStringMaker {
    
    func replace(_ range: NSRange, str: String) -> Void {
        if ( !_rangeContains(self.range, range) ) {
            _errorLog("Replace Failed! param 'range' is unlawfulness!", self.attrStr.string);
            return;
        }
        self.attrStr.replaceCharacters(in: range, with: str)
    }
    
    func replace(_ range: NSRange, attrStr: NSAttributedString) -> Void {
        if ( !_rangeContains(self.range, range) ) {
            _errorLog("Replace Failed! param 'range' is unlawfulness!", self.attrStr.string);
            return;
        }
        self.attrStr.replaceCharacters(in: range, with: attrStr)
    }
    
    func replace(_ range: NSRange, image: UIImage, offset: CGPoint, size: CGSize) -> Void {
        if ( !_rangeContains(self.range, range) ) {
            _errorLog("Replace Failed! param 'range' is unlawfulness!", self.attrStr.string);
            return;
        }
        self.attrStr.replaceCharacters(in: range, with: NSAttributedString.init(attachment: _attachment(image, offset, size)))
    }
}


// MARK: 移除 - remove

public extension SJAttributesStringMaker {
    
    /// 删除文本
    func removeText(_ range: NSRange) -> Void {
        if !_rangeContains(self.range, range) {
            _errorLog("Delete Text Failed! param 'range' is unlawful!", self.attrStr.string)
        }
        self.attrStr.deleteCharacters(in: range)
    }
    
    /// 删除属性
    func removeAttribute(_ key: NSAttributedString.Key, _ range: NSRange) -> Void {
        if !_rangeContains(self.range, range) {
            _errorLog("Delete Text Failed! param 'range' is unlawful!", self.attrStr.string)
        }
        self.attrStr.removeAttribute(key, range: range)
    }
    
    /// 删除属性
    func removeAttributes(_ range: NSRange) -> Void {
        if !_rangeContains(self.range, range) {
            _errorLog("Delete Text Failed! param 'range' is unlawful!", self.attrStr.string)
        }
        let subStr = self.subAttrStr(range)!.string
        self.replace(range, str: subStr)
    }
}

// MARK: property

public extension SJAttributesRangeOperator {
    /// 字体
    @discardableResult
    func font(_ font: UIFont) -> SJAttributesRangeOperator {
        self.recorder.font = font
        return self
    }
    
    /// 文本颜色
    @discardableResult
    func textColor(_ textColor: UIColor) -> SJAttributesRangeOperator {
        self.recorder.textColor = textColor
        return self
    }
    
    /// 放大, 扩大
    @discardableResult
    func expansion(_ expansion: Double) -> SJAttributesRangeOperator {
        recorder.expansion = expansion
        return self;
        
    }
    
    /// 阴影
    @discardableResult
    func shadow(shadowOffset: CGSize, shadowBlurRadius: CGFloat?, shadowColor: UIColor ) -> SJAttributesRangeOperator {
        if ( nil != self.recorder.backgroundColor ) {
            _errorLog("`shadow`会与`backgroundColor`冲突, 设置了`backgroundColor`后, `shadow`将不会显示.", self.recorder.range as Any);
        }
        let shadow = NSShadow()
        shadow.shadowOffset = shadowOffset
        if ( nil != shadowBlurRadius ) {
            shadow.shadowBlurRadius = shadowBlurRadius!
        }
        shadow.shadowColor = shadowColor
        recorder.shadow = shadow
        return self;
    }
    
    /// 阴影
    @discardableResult
    func shadow(shadowOffset: CGSize, shadowColor: UIColor ) -> SJAttributesRangeOperator {
        return self.shadow(shadowOffset: shadowOffset, shadowBlurRadius: nil, shadowColor: shadowColor)
    }
    
    /// 背景颜色
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> SJAttributesRangeOperator {
        if ( nil != self.recorder.shadow ) {
            _errorLog("`shadow`会与`backgroundColor`冲突, 设置了`backgroundColor`后, `shadow`将不会显示.", self.recorder.range as Any);
        }
        recorder.backgroundColor = backgroundColor
        return self
    }
    
    /// 下划线
    @discardableResult
    func underLine(_ style: NSUnderlineStyle, _ color: UIColor) -> SJAttributesRangeOperator {
        recorder.underLine = SJUnderlineAttribute.init(style, color)
        return self
    }
    
    /// 删除线
    @discardableResult
    func strikethrough(_ style: NSUnderlineStyle, _ color: UIColor) -> SJAttributesRangeOperator {
        recorder.strikethrough = SJUnderlineAttribute.init(style, color)
        return self
    }
    
    /// 边界
    @discardableResult
    func stroke(_ color: UIColor, _ stroke: Double) -> SJAttributesRangeOperator {
        recorder.stroke = SJStrokeAttribute.init(stroke, color)
        return self
    }
    
    /// 倾斜(-1 ... 1)
    @discardableResult
    func obliqueness(_ obliqueness: Double) -> SJAttributesRangeOperator {
        recorder.obliqueness = obliqueness
        return self
    }
    
    /// 字间隔
    @discardableResult
    func letterSpacing(_ letterSpacing: Double) -> SJAttributesRangeOperator {
        recorder.letterSpacing = letterSpacing
        return self
    }
    
    /// 上下偏移
    @discardableResult
    func offset(_ offset: Double) -> SJAttributesRangeOperator {
        recorder.offset = offset
        return self
    }
    
    /// 链接
    @discardableResult
    func isLink() -> SJAttributesRangeOperator {
        recorder.link = true
        return self
    }
    
    /// 段落 style
    @discardableResult
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        return self
    }
    
    /// 行间隔
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.lineSpacing = lineSpacing
        return self
    }
    
    /// 段后间隔(\n)
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.paragraphSpacing = paragraphSpacing
        return self
    }
    
    /// 段前间隔(\n)
    @discardableResult
    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    /// 首行头缩进
    @discardableResult
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    /// 左缩进
    @discardableResult
    func headIndent(_ headIndent: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.headIndent = headIndent
        return self
    }
    
    /// 右缩进(正值从左算起, 负值从右算起)
    @discardableResult
    func tailIndent(_ tailIndent: CGFloat) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.tailIndent = tailIndent
        return self
    }
    
    /// 对齐方式
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.alignment = alignment
        return self
    }
    
    /// 截断模式
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> SJAttributesRangeOperator {
        recorder.paragraphStyleM.lineBreakMode = lineBreakMode
        return self
    }

}


// MARK: 记录 - recorder

fileprivate struct SJStrokeAttribute {
    init(_ value: Double, _ color: UIColor) {
        self.value = value
        self.color = color
    }
    var value: Double
    var color: UIColor
    
    func copy(with zone: NSZone? = nil) -> Any {
        let new = SJStrokeAttribute.init(value, color)
        return new
    }
}

fileprivate struct SJUnderlineAttribute {
    init(_ value: NSUnderlineStyle, _ color: UIColor) {
        self.value = value
        self.color = color
    }
    var value: NSUnderlineStyle
    var color: UIColor
    
    func copy(with zone: NSZone? = nil) -> Any {
        let new = SJUnderlineAttribute.init(value, color)
        return new
    }
}

private class SJAttributesRecorder: NSObject, NSCopying {
    
    func addAttributes(_ attrStr: NSMutableAttributedString) -> Void {
        var range = self.range
        
        if ( nil == range ) {
            range = NSRange.init(location: 0, length: attrStr.length)
        }
        if nil != self.font {
            attrStr.addAttribute(NSAttributedString.Key.font, value: self.font!, range: range!)
        }
        if nil != self.textColor {
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: self.textColor!, range: range!)
        }
        if nil != self.expansion {
            attrStr.addAttribute(NSAttributedString.Key.expansion, value: self.expansion!, range: range!)
        }
        if nil != self.shadow {
            attrStr.addAttribute(NSAttributedString.Key.shadow, value: self.shadow!, range: range!)
        }
        if nil != self.backgroundColor {
            attrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: self.backgroundColor!, range: range!)
        }
        if nil != self.underLine {
            attrStr.addAttribute(NSAttributedString.Key.underlineStyle, value: self.underLine!.value.rawValue, range: range!)
            attrStr.addAttribute(NSAttributedString.Key.underlineColor, value: self.underLine!.color, range: range!)
        }
        if nil != self.strikethrough {
            attrStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: self.strikethrough!.value.rawValue, range: range!)
            attrStr.addAttribute(NSAttributedString.Key.strikethroughColor, value: self.strikethrough!.color, range: range!)
        }
        if nil != self.stroke {
            attrStr.addAttribute(NSAttributedString.Key.strokeWidth, value: self.stroke!.value, range: range!)
            attrStr.addAttribute(NSAttributedString.Key.strokeColor, value: self.stroke!.color, range: range!)
        }
        if nil != self.obliqueness {
            attrStr.addAttribute(NSAttributedString.Key.obliqueness, value: self.obliqueness!, range: range!)
        }
        if nil != self.letterSpacing {
            attrStr.addAttribute(NSAttributedString.Key.kern, value: self.letterSpacing!, range: range!)
        }
        if nil != self.offset {
            attrStr.addAttribute(NSAttributedString.Key.baselineOffset, value: self.offset!, range: range!)
        }
        if nil != self.link {
            attrStr.addAttribute(NSAttributedString.Key.link, value: true, range: range!)
        }
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: self.paragraphStyleM, range: range!)
    }
    
    var range: NSRange?
    
    var font: UIFont?
    
    var textColor: UIColor?
    
    var expansion: Double?
    
    var shadow: NSShadow?
    
    var backgroundColor: UIColor?
    
    var underLine: SJUnderlineAttribute?
    
    var strikethrough: SJUnderlineAttribute?
    
    var stroke: SJStrokeAttribute?
    
    var obliqueness: Double?
    
    var letterSpacing: Double?
    
    var offset: Double?
    
    var link: Bool?
    
    var paragraphStyleM: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    
    var lineSpacing: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.lineSpacing = newV!
        }
        
        get {
            return self.paragraphStyleM.lineSpacing
        }
    }
    
    var paragraphSpacing: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.paragraphSpacing = newV!
        }
        
        get {
            return self.paragraphStyleM.paragraphSpacing
        }
    }
    
    var paragraphSpacingBefore: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.paragraphSpacingBefore = newV!
        }
        
        get {
            return self.paragraphStyleM.paragraphSpacingBefore
        }
    }
    
    var firstLineHeadIndent: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.firstLineHeadIndent = newV!
        }
        
        get {
            return self.paragraphStyleM.firstLineHeadIndent
        }
    }
    
    var headIndent: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.headIndent = newV!
        }
        
        get {
            return self.paragraphStyleM.headIndent
        }
    }
    
    var tailIndent: CGFloat? {
        set {
            var newV = newValue
            if nil == newValue { newV = CGFloat.init()}
            self.paragraphStyleM.tailIndent = newV!
        }
        
        get {
            return self.paragraphStyleM.tailIndent
        }
    }
    
    var alignment: NSTextAlignment? {
        set {
            var newV = newValue
            if nil == newValue { newV = NSTextAlignment.left}
            self.paragraphStyleM.alignment = newV!
        }
        
        get {
            return self.paragraphStyleM.alignment
        }
    }
    
    var lineBreakMode: NSLineBreakMode? {
        set {
            var newV = newValue
            if nil == newValue { newV = NSLineBreakMode.byWordWrapping}
            self.paragraphStyleM.lineBreakMode = newV!
        }
        
        get {
            return self.paragraphStyleM.lineBreakMode
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let new = SJAttributesRecorder.init()
        new.range = range
        new.font = font
        new.textColor = textColor
        new.expansion = expansion
        new.shadow = shadow
        new.backgroundColor = backgroundColor
        new.underLine = underLine
        new.strikethrough = strikethrough
        new.stroke = stroke
        new.obliqueness = obliqueness
        new.letterSpacing = letterSpacing
        new.offset = offset
        new.link = link
        new.paragraphStyleM = paragraphStyleM.mutableCopy() as! NSMutableParagraphStyle
        return self
    }
    
}


// MARK: 辅助 - other func

fileprivate func _rangeContains(_ range: NSRange, _ subRange: NSRange) -> Bool {
    return (range.location <= subRange.location) && (range.location + range.length >= subRange.location + subRange.length)
}

fileprivate func _errorLog(_ msg: String, _ rangeStr: Any) {
    print("\n__Error__: \(msg)\nTarget: \(rangeStr)");
}

fileprivate func _attachment(_ image: UIImage, _ offset: CGPoint, _ size: CGSize) -> NSTextAttachment {
    let attachment = NSTextAttachment.init()
    attachment.image = image
    attachment.bounds = CGRect.init(origin: offset, size: size)
    return attachment;
}

private var kLastInsertedRange: String?
