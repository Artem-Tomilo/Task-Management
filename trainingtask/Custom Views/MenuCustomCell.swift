//
//  MenuCustomCell.swift
//  trainingtask
//
//  Created by Артем Томило on 19.09.22.
//

import UIKit

class MenuCustomCell: UITableViewCell {
    private let label = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = ""
    }
    
    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20.0),
            label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -20.0),
        ])
    }
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
}
