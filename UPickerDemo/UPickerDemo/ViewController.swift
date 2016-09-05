//
//  ViewController.swift
//  UPickerDemo
//
//  Created by wen on 16/7/27.
//  Copyright © 2016年 wenfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var titles = [
        "Default",
        "Multiple Group Data",
        "Nested Data"
    ]
    var buttons = [UIButton]()
    let buttinTitles = ["select a device", "select a mobile device", "select a Apple device"]
    var pickers: [UPicker?] = [nil, nil, nil]
    var datas = [[["Computer", "Mobile", "Watch", "VR Glass"]], [["iOS", "Android"], ["phone", "pad"]], [["iPhone", "iPad"]]]
    var subData = [
        "iPhone": ["6s", "6s plus", "Others"],
        "iPad": ["Air", "Pro", "Others"],
        "6s": ["32GB", "64GB", "128GB"],
        "6s plus": ["32GB", "64GB", "128GB"]
    ]
    var selecteds = [[0], [0, 0], [0, 0, 0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for (index, text) in titles.enumerate() {
            
            // create label
            let label = UILabel(frame: CGRect(x: 16, y: 90 * index + 60, width: 300, height: 20))
            label.font = label.font.fontWithSize(14)
            label.text = text
            view.addSubview(label)
            
            // create button
            let button = UIButton(frame: CGRect(x: 16, y: 90 * index + 90, width: 220, height: 36))
            button.backgroundColor = view.tintColor
            button.setTitle(buttinTitles[index], forState: .Normal)
            button.addTarget(self, action: #selector(self.showPicker(_:)), forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.tag = index
            view.addSubview(button)
        }
        
    }
    
    func showPicker(sender: UIButton) {
        let index = sender.tag
        if pickers[index] == nil {
            
            // init picker when it is nil
            let picker = UPicker(frame: view.frame, didDisappear: {selected in
                if let rows = selected {
                    self.selecteds[index] = rows
                    
                    if self.pickers[index]!.pickerView.isNested {
                       self.datas[index] = self.pickers[index]!.pickerView.data
                    }
                    
                    var title = ""
                    for (i, s) in rows.enumerate() {
                        title += " " + self.datas[index][i][s]
                    }
                    sender.setTitle(title, forState: .Normal)
                }
            })
            
            // config picker
            switch index {
            case 1: break
            case 2:
                picker.pickerView.isNested = true
                picker.pickerView.hierarchies = 3
                picker.pickerView.subData = subData
                picker.pickerView.doneButton.setTitleColor(UIColor.redColor(), forState: .Normal)
//                picker.modalTransitionStyle = .FlipHorizontal
            default:
                break
            }
            
            pickers[index] = picker
        }
        
        pickers[index]!.pickerView.data = datas[index]
        pickers[index]!.pickerView.selectedRows = selecteds[index]
        pickers[index]!.present(self)
    }

}

