//
//  SettingsLabel.swift
//  trainingtask
//
//  Created by Артем Томило on 27.09.22.
//

import UIKit

class SettingsLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = .white
        font = UIFont.boldSystemFont(ofSize: 16)
        numberOfLines = 0
        backgroundColor = .systemRed
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
