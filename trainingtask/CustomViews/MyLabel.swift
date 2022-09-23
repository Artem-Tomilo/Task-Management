//
//  MyLabel.swift
//  trainingtask
//
//  Created by Артем Томило on 20.09.22.
//

import UIKit

class MyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = .black
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.3
        font = UIFont.systemFont(ofSize: 14)
        numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
