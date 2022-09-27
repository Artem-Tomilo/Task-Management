//
//  MyTextField.swift
//  trainingtask
//
//  Created by Артем Томило on 21.09.22.
//

import UIKit

class MyTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        borderStyle = .roundedRect
        returnKeyType = .done
        enablesReturnKeyAutomatically = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
