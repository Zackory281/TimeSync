//
//  UIPlaceHolderTextField.swift
//  TimeSync
//
//  Created by Zackory Cramer on 12/2/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

@IBDesignable
class UIPlaceHolderTextField: UITextField, UITextFieldDelegate{
    
    @IBInspectable
    var placeHolder:String = ""
    var initiated = false
    //}
    //textView.text = "Placeholder"
    //textView.textColor = UIColor.lightGray

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textColor = UIColor.black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.text! == ""{
            self.text = placeHolder
            self.textColor = UIColor.lightGray
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard !initiated else { return }
        self.text = placeHolder
        self.textColor = UIColor.lightGray
        initiated = true
    }
}
