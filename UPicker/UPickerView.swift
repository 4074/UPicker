//
//  UPickerView.swift
//  UPickerDemo
//
//  Created by wen on 16/7/27.
//  Copyright © 2016年 wenfeng. All rights reserved.
//

import UIKit

public class UPickerView: UIView {
    
    public var duration = 0.4
    
    // height of views
    public var height = (
        widget: CGFloat(248),
        picker: CGFloat(216),
        bar: CGFloat(32)
    )
    
    // width of views
    public var width = (
        button: CGFloat(56)
    )
    
    public let widgetView = UIView()
    public let blankView = UIView()
    public let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    public let pickerView = UIPickerView()
    public let barView = UIView()
    public let doneButton = UIButton()
    
    var data = [[String]]()
    var selectedRows = [Int]()
    var textColor = UIColor.blackColor()
    
    var subData = [String: [String]]()
    var isNested = false
    var hierarchies = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        let frame = self.frame
        
        // reset frame of views
        widgetView.frame = CGRect(x: 0, y: frame.height - height.widget, width: frame.width, height: height.widget)
        blankView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - height.widget)
        
        pickerView.frame = CGRect(x: 0, y: height.bar, width: frame.width, height: height.picker)
        
        barView.frame = CGRect(x: 0, y: 0, width: frame.width, height: height.bar)
        blurView.frame = barView.frame
        doneButton.frame = CGRect(x: frame.width - width, y: 0, width: width, height: height.bar)
    }
    
    func initView() {
        self.addSubview(widgetView)
        
        // blur view
        widgetView.addSubview(blurView)
        blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // blank view
        self.addSubview(blankView)
        
        // date picker view
        widgetView.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.whiteColor()
        
        // bar view and done button
        widgetView.addSubview(barView)
        barView.addSubview(doneButton)
        doneButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(self.tintColor, forState: .Normal)
    }
    
    func render() {
        
        if isNested {
            while data.count < hierarchies {
                let selected = data[data.count - 1][selectedRows[data.count - 1]]
                if let sub = subData[selected] {
                    data.append(sub)
                } else {
                    data.append([])
                }
            }
            
        }
        
        pickerView.reloadAllComponents()
        for (index, row) in selectedRows.enumerate() {
            pickerView.selectRow(row, inComponent: index, animated: false)
            
        }
    }
    
    func rerender(index: Int) {
        
        for i in index..<hierarchies {
            let selected = data[i - 1][selectedRows[i - 1]]
            if let sub = subData[selected] {
                data[i] = sub
            } else {
                data[i] = []
            }
            
            if i < selectedRows.count {
                selectedRows[i] = 0
            } else {
                selectedRows.append(0)
            }
            pickerView.reloadComponent(i)
            pickerView.selectRow(selectedRows[i], inComponent: i, animated: true)
        }
    }
}

extension UPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }
    
    public func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = data[component][row]
        let attrs = [NSForegroundColorAttributeName: textColor]
        
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component < selectedRows.count {
            selectedRows[component] = row
        } else {
            selectedRows.append(row)
        }
        
        if isNested {
            rerender(component + 1)
        }
    }
}
