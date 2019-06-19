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
        for i in 0...3 {
            let model = SJDemoInfo.init()
            switch (i) {
            case 0:
                model.name = "\(i) 常用方法"
                                
                let text = NSAttributedString.sj.makeText({ (make) in
                    make.font(.boldSystemFont(ofSize: 20)).textColor(.black).lineSpacing(8)
                    
                    make.append(":Image - ")
                    make.append({ (make) in
                        make.image = UIImage.init(named: "sample2")
                        make.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                    })
                    make.append("\n")
                    make.append(":UnderLine").underLine({ (make) in
                        make.style = .single
                        make.color = .green
                    })
                    make.append("\n")
                    make.append(":Strikethrough").strikethrough({ (make) in
                        make.style = .single
                        make.color = .green
                    })
                    make.append("\n")
                    make.append(":BackgroundColor").backgroundColor(.green)
                    
                    make.append("\n")
                    make.append(":Kern").kern(6)
                    
                    make.append("\n")
                    let shadow = NSShadow.init()
                    shadow.shadowColor = UIColor.red
                    shadow.shadowOffset = .init(width: 0, height: 1)
                    shadow.shadowBlurRadius = 5
                    make.append(":Shadow").shadow(shadow)
                    
                    make.append("\n")
                    make.append(":Stroke").stroke({ (make) in
                        make.color = .red
                        make.width = 1
                    })
                    
                    make.append("\n")
                    make.append("oOo").font(.boldSystemFont(ofSize: 25)).alignment(.center)
                    
                    make.append("\n")
                    make.append("Regular Expression")
                    make.regex("Regular").update({ (make) in
                        make.font(.boldSystemFont(ofSize: 25)).textColor(.purple)
                    })
                    make.regex("ss").replace("SS")
                    make.regex("on").replace({ (make) in
                        make.append("ON😆").textColor(.red).backgroundColor(.green).font(.boldSystemFont(ofSize: 30))
                    })
                });
                
                model.size = text.sj_textSize(forPreferredMaxLayoutWidth: self.view.bounds.size.width - 80)
                
                model.task = { return text }
                break;
            case 1:
                model.name = "\(i) 正则匹配"
                let text = NSAttributedString.sj.makeText({ (make) in
                    make.append("@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#")
                    
                    make.regex("[@][^\\s]+\\s").update({ (make) in
                        make.font(.boldSystemFont(ofSize: 25)).textColor(.purple)
                    })
                    
                    make.regex("[#][^#]+#").update({ (make) in
                        make.font(.boldSystemFont(ofSize: 25)).textColor(.purple)
                    })
                })
                
                model.size = text.sj_textSize(forPreferredMaxLayoutWidth: self.view.bounds.size.width - 80)
                model.task = { return text }
                break;
            case 2:
                model.name = "\(i) 上下图文"
                let text = NSAttributedString.sj.makeText({ (make) in
                    make.alignment(NSTextAlignment.center).lineSpacing(8)
                    make.append({ (make) in
                        make.image = UIImage.init(named: "sample2")
                        make.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                    })
                    
                    make.append("\n999")
                })
                
                model.size = text.sj_textSize(forPreferredMaxLayoutWidth: self.view.bounds.size.width - 80)
                model.task = { return text }
                break;
            default:
                model.name = "\(i) 图文对齐"
                let text = NSAttributedString.sj.makeText { (make) in
                    make.font(UIFont.systemFont(ofSize: 14))
                    make.append("Top->")
                    make.append({ (make) in
                        make.image = UIImage.init(named: "sample2")
                        make.alignment = .top
                    })
                    
                    make.append("Center->")
                    make.append({ (make) in
                        make.image = UIImage.init(named: "sample2")
                        make.alignment = .center
                    })
                    
                    make.append("Bottom->")
                    make.append({ (make) in
                        make.image = UIImage.init(named: "sample2")
                        make.alignment = .bottom
                    })
                }
                
                model.size = text.sj_textSize(forPreferredMaxLayoutWidth: self.view.bounds.size.width - 80)
                model.task = { return text }
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
