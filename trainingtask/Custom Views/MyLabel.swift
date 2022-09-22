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
        layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 0.3
        font = UIFont.systemFont(ofSize: 14)
        backgroundColor = .systemGray6
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
