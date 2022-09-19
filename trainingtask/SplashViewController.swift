//
//  SplashViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 16.09.22.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var nameLabel = UILabel()
    private var versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let delay = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            // transition to next VC
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(versionLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            versionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        nameLabel.attributedText = NSAttributedString(string: "TrainingTask", attributes: [.font: UIFont.systemFont(ofSize: 25)])
        nameLabel.textAlignment = .center
        
        versionLabel.attributedText = NSAttributedString(string: "Version 1.0", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        versionLabel.textAlignment = .center
    }
}
