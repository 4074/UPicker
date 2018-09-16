//
//  UPickerView.swift
//  UPickerDemo
//
//  Created by wen on 16/7/27.
//  Copyright © 2016年 wenfeng. All rights reserved.
//

import UIKit

open class UPickerView: UIView {
    
    // present animation duration
    open var duration = 0.4
    
    // height of views
    open var height = (
        widget: CGFloat(248),
        picker: CGFloat(216),
        bar: CGFloat(32)
    )
    
    // width of views
    open var width = (
        CGFloat(56)
    )
    
    // the wrapper of pickerView and toolbar
    public let widgetView = UIView()
    
    // a transparent view on top of widgetView
    // could be touched, and disappear this widget on event `tounchInSide`
    public let blankView = UIView()
    
    // blur background view of toolbar
    public let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
    
    // native picker view
    public let pickerView = UIPickerView()
    
    // toolbar
    public let barView = UIView()
    
    // doneButton
    public let doneButton = UIButton()
    
    // the data will be show in picker view
    open var data = [[String]]()
    // selected row of pikcer view
    open var selectedRows = [Int]()
    // pick view textColor
    open var textColor = UIColor.black
    
    // hierarchy count
    // if it greater than 0, detect widget is in nested mode or not
    open var nestedHierarchy = 0
    
    // nestedData
    // key is the title of parent
    // value is a new component data
    open var nestedData = [String: [String]]()
    
    /**
     * Override init function
     * Init widget view
     * Bind picker view dataSource and delegate to self
     *
     * @param frame:CGRect frame of view
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Override layoutSubviews function
     * Change views frame to adapt
     * Mostly be used when device orientation change
     */
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.frame
        
        // reset frame of views
        widgetView.frame = CGRect(x: 0, y: frame.height - height.widget, width: frame.width, height: height.widget)
        blankView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - height.widget)
        
        pickerView.frame = CGRect(x: 0, y: height.bar, width: frame.width, height: height.picker)
        
        barView.frame = CGRect(x: 0, y: 0, width: frame.width, height: height.bar)
        blurView.frame = barView.frame
        doneButton.frame = CGRect(x: frame.width - width, y: 0, width: width, height: height.bar)
    }
    
    /**
     * init view function
     * init all views in this widget
     */
    open func initView() {
        self.addSubview(widgetView)
        
        // blur view
        widgetView.addSubview(blurView)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // blank view
        self.addSubview(blankView)
        
        // date picker view
        widgetView.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.white
        
        // bar view and done button
        widgetView.addSubview(barView)
        barView.addSubview(doneButton)
        
        // style button
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.setTitleColor(self.tintColor, for: UIControlState())
    }
    
    /**
     * Render the pickerView.
     * If in nested mode, it will evaluate the correct `data`
     */
    open func render() {
        
        // evaluate `data` if in nested mode
        if nestedHierarchy > 0 {
            while data.count < nestedHierarchy {
                let selected = data[data.count - 1][selectedRows[data.count - 1]]
                if let sub = nestedData[selected] {
                    data.append(sub)
                } else {
                    data.append([])
                }
            }
            
        }
        
        // reload all components
        pickerView.reloadAllComponents()
        
        // set selected of rows
        for (index, row) in selectedRows.enumerated() {
            pickerView.selectRow(row, inComponent: index, animated: false)
            
        }
    }
    
    /**
     * Rerender Components if need, when select a prev component.
     * Just be Used in nested mode
     *
     * @private
     * @param index:Int the beginning of component needs rerender
     */
    fileprivate func rerenderComponent(_ index: Int) {
        for i in index..<nestedHierarchy {
            let selected = data[i - 1][selectedRows[i - 1]]
            if let sub = nestedData[selected] {
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
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = data[component][row]
        let attrs = [NSAttributedStringKey.foregroundColor: textColor]
        
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // store selected data in `selectedRows`
        if component < selectedRows.count {
            selectedRows[component] = row
        } else {
            selectedRows.append(row)
        }
        
        // rerender component if in nested mode
        if nestedHierarchy > 0 {
            rerenderComponent(component + 1)
        }
    }
}
