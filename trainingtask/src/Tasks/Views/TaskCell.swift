//
//  TaskCell.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private let background = UIView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let projectLabel = UILabel(frame: .zero)
    private let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        background.addSubview(nameLabel)
        background.addSubview(projectLabel)
        background.addSubview(image)
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            background.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -50),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            projectLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            projectLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            projectLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -50),
            projectLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            image.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
            image.widthAnchor.constraint(equalToConstant: 40),
            image.heightAnchor.constraint(equalToConstant: 40),
            image.centerYAnchor.constraint(equalTo: background.centerYAnchor),
        ])
        
        background.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        projectLabel.alpha = 0.7
    }
    
    func bindText(nameText: String, projectText: String) {
        nameLabel.text = nameText
        projectLabel.text = projectText
    }
    
    func changeImage(status: TaskStatus) {
        image.image = status.imageView
    }
    
    func hideProjectLabel() {
        projectLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            background.backgroundColor =  .gray
            nameLabel.textColor = .white
            projectLabel.textColor = .white
        } else {
            background.backgroundColor =  .white
            nameLabel.textColor = .black
            projectLabel.textColor = .black
        }
    }
}
