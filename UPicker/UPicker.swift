//
//  UPicker.swift
//  UPickerDemo
//
//  Created by wen on 16/7/27.
//  Copyright © 2016年 wenfeng. All rights reserved.
//

import UIKit

open class UPicker: UIViewController {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // picker view whick includes all views of widget
    open var pickerView: UPickerView!
    open var didDisappear: (([Int]?) -> Void)? = nil
    
    // render picker view before widget appear
    override open func viewWillAppear(_ animated: Bool) {
        pickerView.render()
    }
    
    // init widget and bind event
    public init(frame: CGRect, didDisappear: (([Int]?) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.didDisappear = didDisappear
        
        // init picker view
        pickerView = UPickerView(frame: frame)
        self.view = pickerView
        
        pickerView.doneButton.addTarget(self, action: #selector(self.handleDoneButtonTap), for: .touchUpInside)
        
        let tapBlankGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBlankViewTap))
        pickerView.blankView.addGestureRecognizer(tapBlankGesture)
    }
    
    // present the view controller
    open func present(_ previous: UIViewController) {
        previous.present(self, animated: true, completion: nil)
    }
    
    /**
     * Handle blank view tap event.
     * Disappear widget without selectedRows.
     */
    @objc open func handleBlankViewTap() {
        self.dismiss(animated: true, completion: {
            if self.didDisappear != nil {
                self.didDisappear!(nil)
            }
        })
    }
    
    /**
     * Handle done button tap event.
     * Disappear widget with selectedRows.
     * If in nested mode, evaluate the correct selectedRows
     */
    @objc open func handleDoneButtonTap() {
        self.dismiss(animated: true, completion: {
            if self.didDisappear != nil {
                var selected = [Int]()
                for (index, item) in self.pickerView.data.enumerated() {
                    if !item.isEmpty {
                        selected.append(self.pickerView.selectedRows[index])
                    }
                }
                self.didDisappear!(selected)
            }
        })
    }
}

