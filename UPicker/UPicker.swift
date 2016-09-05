//
//  UPicker.swift
//  UPickerDemo
//
//  Created by wen on 16/7/27.
//  Copyright © 2016年 wenfeng. All rights reserved.
//

import UIKit

public class UPicker: UIViewController {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var pickerView: UPickerView!
    public var didDisappear: (([Int]?) -> Void)? = nil
    
    override public func viewWillAppear(animated: Bool) {
        pickerView.render()
    }
    
    public init(frame: CGRect, didDisappear: (([Int]?) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.didDisappear = didDisappear
        
        // init picker view
        pickerView = UPickerView(frame: frame)
        self.view = pickerView
        
        pickerView.doneButton.addTarget(self, action: #selector(self.handleDoneButtonTap), forControlEvents: .TouchUpInside)
        
        let tapBlankGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBlankViewTap))
        pickerView.blankView.addGestureRecognizer(tapBlankGesture)
    }
    
    // present the view controller
    public func present(previous: UIViewController) {
        previous.presentViewController(self, animated: true, completion: nil)
    }
    
    public func handleBlankViewTap() {
        self.dismissViewControllerAnimated(true, completion: {
            if self.didDisappear != nil {
                self.didDisappear!(nil)
            }
        })
    }
    
    public func handleDoneButtonTap() {
        self.dismissViewControllerAnimated(true, completion: {
            if self.didDisappear != nil {
                var selected = [Int]()
                for (index, item) in self.pickerView.data.enumerate() {
                    if !item.isEmpty {
                        selected.append(self.pickerView.selectedRows[index])
                    }
                }
                self.didDisappear!(selected)
            }
        })
    }
}

