//
//  ViewController.swift
//  SwiftVersion
//
//  Created by BlueDancer on 2018/1/28.
//  Copyright © 2018年 畅三江. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var demosM: [SJDemoInfo] = [SJDemoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.6
        label.numberOfLines = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.createExamples()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func createExamples() -> Void {
        for i in 0...10 {
            let model = SJDemoInfo.init()
            switch (i) {
            case 0:
                model.name = "\(i) 常用方法"
                model.task = {
                    return sj_makeAttributesString({ (make) in
                        make.insertText("叶秋笑了笑，抬手取下了衔在嘴角的烟头。", 0)
                        make
                            .font(UIFont.systemFont(ofSize: 40))                         // 设置字体
                            .textColor(UIColor.black)                                    // 设置文本颜色
                            .underLine(NSUnderlineStyle.styleSingle, UIColor.orange)     // 设置下划线
                            .strikethrough(NSUnderlineStyle.styleSingle, UIColor.orange) // 设置删除线
                            .stroke(UIColor.green, 1)                                    // 字体边缘的颜色, 设置后, 字体会镂空
                            .obliqueness(0.3)                                            //  倾斜
                            .letterSpacing(4)                                            // 字体间隔
                            .lineSpacing(4)                                              // 行间隔
                            .alignment(NSTextAlignment.center)                           // 对其方式
//                          .shadow(CGSizeMake(0.5, 0.5), 0, UIColor.red)                // 设置阴影
//                          .backgroundColor(UIColor.white)                              // 设置文本背景颜色
//                          .offset(-10)                                                 // 上下偏移
                        model.size = make.size(byMaxWidth: self.view.bounds.size.width - 80)
                    })
                }
                break;
            case 1:
                model.name = "\(i) 正则匹配"
                model.task = {
                    return sj_makeAttributesString({ (make) in
                        make.insertText("@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#", 0)
                        
                        make.regexp("[@][^\\s]+\\s", matchedTask: { (matched) in
                            matched.textColor(UIColor.purple)
                        })
                        
                        make.regexp("[#][^#]+#", matchedTask: { (matched) in
                            matched.textColor(UIColor.orange)
                        })
                        
                        model.size = make.size(byMaxWidth: self.view.bounds.size.width - 80)
                    })
                }
                break;
            case 2:
                model.name = "\(i) 上下图文"
                model.task = {
                    return sj_makeAttributesString({ (make) in
                        make.insertImage(UIImage.init(named: "sample2")!, 0, CGPoint.init(), CGSize.init(width: 30, height: 30))
                        make.insertText("\n999", -1).alignment(NSTextAlignment.center).lineSpacing(4)
                        model.size = make.size()
                    })
                }
                break;
            case 3:
                model.name = "\(i) 下划线 + 删除线"
                model.task = {
                    return sj_makeAttributesString({ (make) in
                        make.font(UIFont.boldSystemFont(ofSize: 25))
                        make.insertText("下划线", 0)
                        make.lastInserted({ (lastOperator) in
                            lastOperator.underLine(NSUnderlineStyle.styleSingle, UIColor.red)
                        })
                        
                        make.insertText("-----", -1)
                        
                        make.insertText("删除线", -1)
                        make.lastInserted({ (lastOperator) in
                            lastOperator.strikethrough(NSUnderlineStyle.styleSingle, UIColor.red)
                        })

                        model.size = make.size()
                    })
                }
                break
            default:
                model.name = "\(i) 备用"
                break;
            }
            demosM.append(model)
        }
        
    }
    
    func _updateHeightConstraint(_ size: CGSize) -> Void {
        widthConstraint.constant = size.width
        heightConstraint.constant = size.height
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ( nil != demosM[indexPath.row].task ) {
            self.tipsLabel.text = demosM[indexPath.row].name
            label.attributedText = demosM[indexPath.row].task!()
            self._updateHeightConstraint(demosM[indexPath.row].size!)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demosM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = demosM[indexPath.row].name
        return cell;
    }
}
