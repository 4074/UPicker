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
        "Simple",
        "Multiple data, custom transition and color",
        "Nested Data"
    ]
    var buttons = [UIButton]()
    let buttinTitles = ["select a device", "select a mobile device", "select a Apple device"]
    var pickers: [UPicker?] = [nil, nil, nil]
    var datas = [[["Computer", "Mobile", "Watch", "VR Glass"]], [["iOS", "Android"], ["phone", "pad"]], [["iPhone", "iPad"]]]
    var nestedData = [
        "iPhone": ["6s", "6s plus", "Others"],
        "iPad": ["Air", "Pro", "Others"],
        "6s": ["32GB", "64GB", "128GB"],
        "6s plus": ["32GB", "64GB", "128GB"]
    ]
    var selecteds = [[0], [0, 0], [0, 0, 0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, text) in titles.enumerated() {
            
            // create label
            let label = UILabel(frame: CGRect(x: 16, y: 90 * index + 60, width: 300, height: 20))
            label.font = label.font.withSize(14)
            label.text = text
            view.addSubview(label)
            
            // create button
            let button = UIButton(frame: CGRect(x: 16, y: 90 * index + 90, width: 220, height: 36))
            button.backgroundColor = view.tintColor
            button.setTitle(buttinTitles[index], for: UIControlState())
            button.addTarget(self, action: #selector(self.showPicker(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.tag = index
            view.addSubview(button)
        }
        
    }
    
    func showPicker(_ sender: UIButton) {
        let index = sender.tag
        if pickers[index] == nil {
            
            // init picker when it is nil
            let picker = UPicker(frame: view.frame, didDisappear: {selected in
                if let rows = selected {
                    self.selecteds[index] = rows
                    
                    if self.pickers[index]!.pickerView.nestedHierarchy > 0 {
                       self.datas[index] = self.pickers[index]!.pickerView.data
                    }
                    
                    // change button title
                    var title = ""
                    for (i, s) in rows.enumerated() {
                        title += " " + self.datas[index][i][s]
                    }
                    sender.setTitle(title, for: UIControlState())
                }
            })
            
            if index == 1 {
                picker.modalTransitionStyle = .flipHorizontal
                picker.pickerView.textColor = view.tintColor
                picker.pickerView.doneButton.setTitleColor(UIColor.red, for: UIControlState())
            } else if index == 2 {
                picker.pickerView.nestedHierarchy = 3
                picker.pickerView.nestedData = nestedData
            }
            
            pickers[index] = picker
        }
        
        // set pickerView data and selected
        pickers[index]!.pickerView.data = datas[index]
        pickers[index]!.pickerView.selectedRows = selecteds[index]
        
        // present picker
        pickers[index]!.present(self)
    }

}

