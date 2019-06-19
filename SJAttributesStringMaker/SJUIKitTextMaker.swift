//
//  SJUIKitTextMaker.swift
//  SwiftVersion
//
//  Created by BlueDancer on 2019/4/15.
//  Copyright © 2019 畅三江. All rights reserved.
//
//  Project: https://github.com/changsanjiang/SJAttributesFactory
//  Email:  changsanjiang@gmail.com
//

import UIKit

public extension NSAttributedString {
    /// ```
    /// let text = NSAttributedString.sj.makeText { (make) in
    ///    make.font(.boldSystemFont(ofSize: 20)).textColor(.black).lineSpacing(8)
    ///    make.append("Hello world!")
    /// }
    ///
    /// // It's equivalent to below code.
    ///
    /// let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    /// paragraphStyle.lineSpacing = 8
    /// let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20),
    ///                   NSAttributedString.Key.foregroundColor:UIColor.black,
    ///                   NSAttributedString.Key.paragraphStyle:paragraphStyle]
    /// let text1 = NSAttributedString.init(string: "Hello world!", attributes: attributes)
    /// ```
    struct sj {
        public static func makeText(_ make:(SJUIKitTextMaker)-> Void)-> NSAttributedString {
            let maker = SJUIKitTextMaker.init()
            make(maker)
            return maker.install()
        }
    }
    
    //    let text = NSAttributedString.sj.makeText({ (make) in
    //        make.font(.boldSystemFont(ofSize: 20)).textColor(.black).lineSpacing(8)
    //
    //        make.append(":Image - ")
    //        make.append({ (make) in
    //            make.image = UIImage.init(named: "sample2")
    //            make.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
    //        })
    //        make.append("\n")
    //        make.append(":UnderLine").underLine({ (make) in
    //            make.style = .single
    //            make.color = .green
    //        })
    //        make.append("\n")
    //        make.append(":Strikethrough").strikethrough({ (make) in
    //            make.style = .single
    //            make.color = .green
    //        })
    //        make.append("\n")
    //        make.append(":BackgroundColor").backgroundColor(.green)
    //
    //        make.append("\n")
    //        make.append(":Kern").kern(6)
    //
    //        make.append("\n")
    //        let shadow = NSShadow.init()
    //        shadow.shadowColor = UIColor.red
    //        shadow.shadowOffset = .init(width: 0, height: 1)
    //        shadow.shadowBlurRadius = 5
    //        make.append(":Shadow").shadow(shadow)
    //
    //        make.append("\n")
    //        make.append(":Stroke").stroke({ (make) in
    //            make.color = .red
    //            make.width = 1
    //        })
    //
    //        make.append("\n")
    //        make.append("oOo").font(.boldSystemFont(ofSize: 25)).alignment(.center)
    //
    //        make.append("\n")
    //        make.append("Regular Expression")
    //        make.regex("Regular").update({ (make) in
    //            make.font(.boldSystemFont(ofSize: 25)).textColor(.purple)
    //        })
    //        make.regex("ss").replace("SS")
    //        make.regex("on").replace({ (make) in
    //            make.append("ON😆").textColor(.red).backgroundColor(.green).font(.boldSystemFont(ofSize: 30))
    //        })
    //    });

    func sj_textSize()-> CGSize {
        return sj_textSize(self, preferredMaxLayoutWidth: CGFloat.greatestFiniteMagnitude, preferredMaxLayoutHeight: CGFloat.greatestFiniteMagnitude)
    }
    
    func sj_textSize(forRange range: NSRange)-> CGSize {
        return sj_textSize(self.attributedSubstring(from: range), preferredMaxLayoutWidth: CGFloat.greatestFiniteMagnitude, preferredMaxLayoutHeight: CGFloat.greatestFiniteMagnitude)
    }
    
    func sj_textSize(forPreferredMaxLayoutWidth width: CGFloat)-> CGSize {
        return sj_textSize(self, preferredMaxLayoutWidth: width, preferredMaxLayoutHeight: CGFloat.greatestFiniteMagnitude)
    }
    
    func sj_textSize(forPreferredMaxLayoutHeight height: CGFloat)-> CGSize {
        return sj_textSize(self, preferredMaxLayoutWidth: CGFloat.greatestFiniteMagnitude, preferredMaxLayoutHeight: height)
    }
    
    private func sj_textSize(_ text: NSAttributedString, preferredMaxLayoutWidth width: CGFloat, preferredMaxLayoutHeight height: CGFloat)-> CGSize {
        let bounds = text.boundingRect(with: CGSize.init(width: width, height: height), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil)
        return CGSize.init(width: ceil(bounds.size.width), height: ceil(bounds.size.height));
    }
}

public extension SJUIKitTextMaker {
    @discardableResult func append(_ string: String)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.string = string
        uts.append(ut)
        return ut
    }
    
    @discardableResult func append(_ image: (inout SJUTAttributes.SJUTImageAttachment)->Void)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.attachment = SJUTImageAttachment()
        image(&ut.recorder.attachment!)
        uts.append(ut)
        return ut
    }
    
    @discardableResult func append(_ subtext: NSAttributedString)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.subtext = subtext.mutableCopy() as? NSMutableAttributedString
        uts.append(ut)
        return ut
    }
    
    @discardableResult func update(_ range: NSRange)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.range = range
        uts.append(ut)
        return ut
    }

    @discardableResult func regex(_ regularExpression: String)-> SJUTRegexHandler {
        let handler = SJUTRegexHandler.init(regularExpression)
        regexs.append(handler)
        return handler
    }
    
    @discardableResult func range(_ range: NSRange)-> SJUTRangeHandler {
        let handler = SJUTRangeHandler.init(range)
        ranges.append(handler)
        return handler
    }
}

public extension SJUTAttributes {
    @discardableResult func font(_ font: UIFont)-> Self {
        recorder.font = font
        return self
    }
    
    @discardableResult func textColor(_ textColor: UIColor)-> Self {
        recorder.textColor = textColor
        return self
    }
    
    @discardableResult func backgroundColor(_ backgroundColor: UIColor)-> Self {
        recorder.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult func alignment(_ alignment: NSTextAlignment)-> Self {
        recorder.alignment = alignment
        return self
    }
    
    @discardableResult func lineSpacing(_ lineSpacing: CGFloat)-> Self {
        recorder.lineSpacing = lineSpacing
        return self
    }
    
    @discardableResult func kern(_ kern: CGFloat)-> Self {
        recorder.kern = kern
        return self
    }
    
    @discardableResult func shadow(_ shadow: NSShadow)-> Self {
        recorder.shadow = shadow
        return self
    }
    
    @discardableResult func stroke(_ stroke: (_ make: inout SJUTStroke)-> Void)-> Self {
        if ( recorder.stroke == nil ) {
            recorder.stroke = SJUTStroke.init()
        }
        stroke(&recorder.stroke!)
        return self
    }
    
    @discardableResult func paragraphStyle(_ paragraphStyle: NSParagraphStyle)-> Self {
        recorder.style = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle
        return self
    }
    
    @discardableResult func lineBreakMode(_ lineBreakMode: NSLineBreakMode)-> Self {
        recorder.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult func underLine(_ underLine: (_ make: inout SJUTDecoration)-> Void)-> Self {
        if ( recorder.underLine == nil ) {
            recorder.underLine = SJUTDecoration.init()
        }
        underLine(&recorder.underLine!)
        return self
    }
    
    @discardableResult func strikethrough(_ strikethrough: (_ make: inout SJUTDecoration)-> Void)-> Self {
        if ( recorder.strikethrough == nil ) {
            recorder.strikethrough = SJUTDecoration.init()
        }
        strikethrough(&recorder.strikethrough!)
        return self
    }
    
    @discardableResult func baseLineOffset(_ baseLineOffset: CGFloat)-> Self {
        recorder.baseLineOffset = baseLineOffset
        return self
    }
}

public extension SJUTRangeHandler {
    func replace(_ subtext: @escaping (SJUIKitTextMaker)->Void) {
        recorder.replaceWithText = subtext
    }
    
    func replace(_ string: String)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.string = string
        recorder.utOfReplaceWithString = ut
        return ut
    }
    
    func update(_ update: @escaping (SJUTAttributes)-> Void) {
        recorder.update = update
    }
}

public extension SJUTRegexHandler {
    func replace(_ subtext: @escaping (SJUIKitTextMaker)->Void) {
        recorder.replaceWithText = subtext
    }
    
    @discardableResult func replace(_ string: String)-> SJUTAttributes {
        let ut = SJUTAttributes.init()
        ut.recorder.string = string
        recorder.utOfReplaceWithString = ut
        return ut
    }
    
    func update(_ update: @escaping (SJUTAttributes)-> Void) {
        recorder.update = update
    }
    
    func handler(_ handler: @escaping (NSMutableAttributedString, NSTextCheckingResult)->Void) {
        recorder.handler = handler
    }
    
    @discardableResult func regularExpressionOptions(_ options: NSRegularExpression.Options)-> Self {
        recorder.regularExpressionOptions = options
        return self
    }
    
    @discardableResult func matchingOptions(_ options: NSRegularExpression.MatchingOptions)-> Self {
        recorder.matchingOptions = options
        return self
    }
}

public class SJUTAttributes {
    fileprivate var recorder = SJUTRecorder.init()
    
    public struct SJUTStroke {
        public var color: UIColor?
        public var width: CGFloat?
    }
    
    public struct SJUTDecoration {
        public var color: UIColor?
        public var style: NSUnderlineStyle?
    }
    
    public enum SJUTVerticalAlignment {
        case bottom
        case center
        case top
    }
    
    public struct SJUTImageAttachment {
        public var image: UIImage?
        public var bounds: CGRect?
        public var alignment: SJUTVerticalAlignment = .bottom
    }
    
    fileprivate struct SJUTRecorder {
        var font: UIFont?
        var textColor: UIColor?
        var backgroundColor: UIColor?
        var alignment: NSTextAlignment?
        var lineSpacing: CGFloat?
        var kern: CGFloat?
        var shadow: NSShadow?
        var stroke: SJUTAttributes.SJUTStroke?
        var style: NSMutableParagraphStyle?
        var lineBreakMode: NSLineBreakMode?
        var underLine: SJUTAttributes.SJUTDecoration?
        var strikethrough: SJUTAttributes.SJUTDecoration?
        var baseLineOffset: CGFloat?
        
        // - sources
        var string: String?
        var range: NSRange?
        var attachment: SJUTAttributes.SJUTImageAttachment?
        var subtext: NSMutableAttributedString?
        
        
        func paragraphStyle()-> NSParagraphStyle {
            if ( style != nil ) {
                return style!
            }
            
            let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            if let lineSpacing = self.lineSpacing {
                style.lineSpacing = lineSpacing
            }
            if let alignment = self.alignment {
                style.alignment = alignment
            }
            if let lineBreakMode = self.lineBreakMode {
                style.lineBreakMode = lineBreakMode
            }
            return style
        }
    }
}

public class SJUIKitTextMaker: SJUTAttributes {
    private var uts = [SJUTAttributes]()
    private var updates = [SJUTAttributes]()
    private var regexs = [SJUTRegexHandler]()
    private var ranges = [SJUTRangeHandler]()
    
    fileprivate func install()-> NSMutableAttributedString {
        setDefaultValuesForCommonUTAttributesRecorder()
        
        var result = NSMutableAttributedString.init()
        appendUTAttributesToResultIfNeeded(&result)
        executeUpdateHandlersIfNeeded(&result)
        
        executeRangeHandlersIfNeeded(&result)
        executeUpdateHandlersIfNeeded(&result)
        
        executeRegexHandlerIfNeeded(&result)
        executeUpdateHandlersIfNeeded(&result)
        return result
    }
    
    private func setDefaultValuesForCommonUTAttributesRecorder() {
        if ( recorder.font == nil ) {
            recorder.font = .systemFont(ofSize: 14)
        }
        
        if ( recorder.textColor == nil ) {
            recorder.textColor = .black;
        }
    }
    
    private func appendUTAttributesToResultIfNeeded(_ result: inout NSMutableAttributedString) {
        if ( uts.count > 0 ) {
            uts.forEach { (ut) in
                if let subtext = convertToUIKitTextForUTAttributes(ut) {
                    result.append(subtext)
                }
            }
            uts.removeAll()
        }
    }
    
    private func executeRangeHandlersIfNeeded(_ result: inout NSMutableAttributedString) {
        if ( ranges.count > 0 ) {
            ranges.forEach { (handler) in
                let recorder = handler.recorder
                
                guard let range = recorder.range else {
                    return
                }
    
                if let ut = recorder.utOfReplaceWithString {
                    executeReplaceWithString(&result, ut: ut, in: range)
                }
                else if let replaceWithText = recorder.replaceWithText {
                    executeReplaceWithText(&result, handler: replaceWithText, in: range)
                }
                else if let update = recorder.update {
                    appendUpdateHandlerToUpdates(update, in: range)
                }
            }
            ranges.removeAll()
        }
    }
    
    private func executeRegexHandlerIfNeeded(_ result: inout NSMutableAttributedString) {
        if ( regexs.count > 0 ) {
            regexs.forEach { (handler) in
                let resultString = result.string
                
                let recorder = handler.recorder
                guard let pattern = recorder.regex else {
                    return
                }
                
                do {
                    let regular = try NSRegularExpression.init(pattern: pattern, options: recorder.regularExpressionOptions ?? NSRegularExpression.Options.init())
                    var checkingResults = [NSTextCheckingResult]()
                    regular.enumerateMatches(in: resultString, options: recorder.matchingOptions, range: textRange(result), using: { (checkingResult, _, _) in
                        if let r = checkingResult {
                            checkingResults.append(r)
                        }
                    })
                    
                    checkingResults.reversed().forEach({ (checkingResult) in
                        let range = checkingResult.range
                        if let update = recorder.update {
                            appendUpdateHandlerToUpdates(update, in: range)
                        }
                        else if let ut = recorder.utOfReplaceWithString {
                            executeReplaceWithString(&result, ut: ut, in: range);
                        }
                        else if let replaceWithText = recorder.replaceWithText {
                            executeReplaceWithText(&result, handler: replaceWithText, in: range)
                        }
                        else if let customHandler = recorder.handler {
                            customHandler(result, checkingResult)
                        }
                    })
                } catch { }
            }
            regexs.removeAll()
        }
    }
    
    private func appendUpdateHandlerToUpdates(_ hander:(SJUTAttributes)-> Void, in range: NSRange) {
        let ut = SJUTAttributes.init()
        ut.recorder.range = range
        hander(ut)
        updates.append(ut)
    }
    
    private func executeReplaceWithString(_ result: inout NSMutableAttributedString, ut: SJUTAttributes, in range: NSRange) {
        if ( rangeContains(textRange(result), range) ) {
            setSubtextCommonValuesToRecorder(&ut.recorder, in: range, result: result)
            if let subtext = convertToUIKitTextForUTAttributes(ut) {
                result.replaceCharacters(in: range, with: subtext)
            }
        }
    }
    
    private func executeReplaceWithText(_ result: inout NSMutableAttributedString, handler: (SJUIKitTextMaker)->Void, in range: NSRange) {
        if ( rangeContains(textRange(result), range) ) {
            let maker = SJUIKitTextMaker.init()
            setCommonValuesForUTAttributesRecorderIfNeeded(maker)
            setSubtextCommonValuesToRecorder(&maker.recorder, in: range, result: result)
            handler(maker)
            result.replaceCharacters(in: range, with: maker.install())
        }
    }
    
    private func executeUpdateHandlersIfNeeded(_ result: inout NSMutableAttributedString) {
        if ( updates.count > 0 ) {
            updates.forEach { (ut) in
                if let target = ut.recorder.range {
                    if ( rangeContains(textRange(result), target) ) {
                        setCommonValuesForUTAttributesRecorderIfNeeded(ut)
                        let textAttributes = convertToUIKitTextAttributesForUTAttributesRecorder(ut.recorder)
                        result.addAttributes(textAttributes, range: target)
                    }
                }
            }
            updates.removeAll()
        }
    }
    
    private func rangeContains(_ main: NSRange, _ sub: NSRange)-> Bool {
        return (main.location <= sub.location) && (main.location + main.length >= sub.location + sub.length);
    }
    
    private func convertToUIKitTextForUTAttributes(_ ut: SJUTAttributes)-> NSMutableAttributedString? {
        var current: NSMutableAttributedString? = nil;
        if let string = ut.recorder.string {
            current = NSMutableAttributedString.init(string: string)
        }
        else if let attachment = ut.recorder.attachment {
            let textAttachment = NSTextAttachment.init()
            textAttachment.image = attachment.image
            textAttachment.bounds = adjustVerticalOffsetOfImageAttachment(attachment.bounds ?? CGRect.zero, attachment.image?.size ?? CGSize.zero, attachment.alignment, self.recorder.font!)
            current = NSAttributedString.init(attachment: textAttachment).mutableCopy() as? NSMutableAttributedString
        }
        
        if let cur = current {
            setCommonValuesForUTAttributesRecorderIfNeeded(ut)
            let textAttributes = convertToUIKitTextAttributesForUTAttributesRecorder(ut.recorder)
            cur.addAttributes(textAttributes, range: textRange(cur))
        }
        else if let subtext = ut.recorder.subtext {
            // ignore common values
            // setCommonValuesForUTAttributesRecorderIfNeeded(ut)
            let textAttributes = convertToUIKitTextAttributesForUTAttributesRecorder(ut.recorder)
            subtext .addAttributes(textAttributes, range: textRange(subtext))
            current = subtext
        }
        
        return current
    }
    
    private func setCommonValuesForUTAttributesRecorderIfNeeded(_ ut: SJUTAttributes) {
        let common = self.recorder
        
        if ( ut.recorder.font == nil ) {
            ut.recorder.font = common.font
        }
        
        if ( ut.recorder.textColor == nil ) {
            ut.recorder.textColor = common.textColor
        }
        
        if ( ut.recorder.backgroundColor == nil ) {
            ut.recorder.backgroundColor = common.backgroundColor
        }
        
        if ( ut.recorder.alignment == nil ) {
            ut.recorder.alignment = common.alignment
        }
        
        if ( ut.recorder.lineSpacing == nil ) {
            ut.recorder.lineSpacing = common.lineSpacing
        }
        
        if ( ut.recorder.lineBreakMode == nil ) {
            ut.recorder.lineBreakMode = common.lineBreakMode
        }
        
        if ( ut.recorder.style == nil ) {
            ut.recorder.style = common.style
        }
        
        if ( ut.recorder.kern == nil ) {
            ut.recorder.kern = common.kern
        }
        
        if ( ut.recorder.stroke == nil ) {
            ut.recorder.stroke = common.stroke
        }
        
        if ( ut.recorder.shadow == nil ) {
            ut.recorder.shadow = common.shadow
        }
        
        if ( ut.recorder.underLine == nil ) {
            ut.recorder.underLine = common.underLine
        }
        
        if ( ut.recorder.strikethrough == nil ) {
            ut.recorder.strikethrough = common.strikethrough
        }
        
        if ( ut.recorder.baseLineOffset == nil ) {
            ut.recorder.baseLineOffset = common.baseLineOffset
        }
    }
    
    private func setSubtextCommonValuesToRecorder(_ recorder: inout SJUTRecorder, in range: NSRange, result: NSAttributedString) {
        if ( rangeContains(textRange(result), range) ) {
            let subtext = result.attributedSubstring(from: range)
            var dict = subtext.attributes(at: 0, effectiveRange: nil)
            recorder.font = dict[NSAttributedString.Key.font] as? UIFont
            recorder.textColor = dict[NSAttributedString.Key.foregroundColor] as? UIColor
        }
    }
    
    private func convertToUIKitTextAttributesForUTAttributesRecorder(_ recorder: SJUTRecorder)-> [NSAttributedString.Key:Any] {
        var dict = [NSAttributedString.Key:Any]()
        dict[NSAttributedString.Key.font] = recorder.font
        dict[NSAttributedString.Key.foregroundColor] = recorder.textColor
        dict[NSAttributedString.Key.paragraphStyle] = recorder.paragraphStyle()
        if ( recorder.backgroundColor != nil ) {
            dict[NSAttributedString.Key.backgroundColor] = recorder.backgroundColor
        }
        if ( recorder.kern != nil ) {
            dict[NSAttributedString.Key.kern] = recorder.kern
        }
        if ( recorder.stroke != nil ) {
            dict[NSAttributedString.Key.strokeColor] = recorder.stroke?.color
            dict[NSAttributedString.Key.strokeWidth] = recorder.stroke?.width
        }
        if ( recorder.shadow != nil ) {
            dict[NSAttributedString.Key.shadow] = recorder.shadow
        }
        if ( recorder.underLine != nil ) {
            dict[NSAttributedString.Key.underlineColor] = recorder.underLine?.color
            dict[NSAttributedString.Key.underlineStyle] = recorder.underLine?.style?.rawValue
        }
        if ( recorder.strikethrough != nil ) {
            dict[NSAttributedString.Key.strikethroughColor] = recorder.strikethrough?.color
            dict[NSAttributedString.Key.strikethroughStyle] = recorder.strikethrough?.style?.rawValue
        }
        if ( recorder.baseLineOffset != nil ) {
            dict[NSAttributedString.Key.baselineOffset] = recorder.baseLineOffset
        }
        return dict
    }
    
    private func adjustVerticalOffsetOfImageAttachment(_ bounds: CGRect, _ imageSize: CGSize, _ alignment: SJUTVerticalAlignment, _ commonFont: UIFont) -> CGRect {
        var r_bounds = bounds;
        switch alignment {
        case .top:
            if ( __CGSizeEqualToSize(CGSize.zero, bounds.size) ) {
                r_bounds.size = imageSize;
            }
            let offset = -(r_bounds.size.height - abs(commonFont.capHeight))
            r_bounds.origin.y = offset
        case .center:
            if ( __CGSizeEqualToSize(CGSize.zero, bounds.size) ) {
                r_bounds.size = imageSize;
            }
            let offset = -(r_bounds.size.height * 0.5 - abs(commonFont.descender))
            r_bounds.origin.y = offset;
        case .bottom: break
        }
        
        return r_bounds
    }
    
    private func textRange(_ text: NSAttributedString)-> NSRange {
        return NSRange.init(location: 0, length: text.length)
    }
}

public class SJUTRangeHandler {
    public required init(_ range: NSRange) {
        recorder.range = range
    }
    
    fileprivate var recorder = SJUTRangeRecorder.init()
    
    fileprivate struct SJUTRangeRecorder {
        var range: NSRange?
        var utOfReplaceWithString: SJUTAttributes?
        var replaceWithText: ((SJUIKitTextMaker)->Void)?
        var update: ((SJUTAttributes)-> Void)?
    }
}

public class SJUTRegexHandler {
    public required init(_ regularExpression: String) {
        recorder.regex = regularExpression
    }
    
    fileprivate var recorder = SJUTRegexRecorder.init()
    
    fileprivate struct SJUTRegexRecorder {
        var regularExpressionOptions: NSRegularExpression.Options?
        var matchingOptions = NSRegularExpression.MatchingOptions.withoutAnchoringBounds
        var utOfReplaceWithString: SJUTAttributes?
        var regex: String?
        var replaceWithText: ((SJUIKitTextMaker)->Void)?
        var update: ((SJUTAttributes)-> Void)?
        var handler: ((NSMutableAttributedString, NSTextCheckingResult)->Void)?
    }
}
