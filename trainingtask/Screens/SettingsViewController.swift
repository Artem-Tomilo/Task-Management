//
//  SettingsViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 27.09.22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var urlLabel = SettingsLabel()
    var urlTextField = MyTextField()
    var maxRecordsLabel = SettingsLabel()
    var maxRecordsTextField = MyTextField()
    var daysLabel = SettingsLabel()
    var daysTextField = MyTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        navigationController?.isNavigationBarHidden = false
        self.title = "Настройки"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        view.addSubview(urlLabel)
        view.addSubview(urlTextField)
        view.addSubview(maxRecordsLabel)
        view.addSubview(maxRecordsTextField)
        view.addSubview(daysLabel)
        view.addSubview(daysTextField)
        
        NSLayoutConstraint.activate([
            urlLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            urlLabel.heightAnchor.constraint(equalToConstant: 50),
            
            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            maxRecordsLabel.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 50),
            maxRecordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maxRecordsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maxRecordsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            maxRecordsTextField.topAnchor.constraint(equalTo: maxRecordsLabel.bottomAnchor, constant: 10),
            maxRecordsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            maxRecordsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            daysLabel.topAnchor.constraint(equalTo: maxRecordsTextField.bottomAnchor, constant: 50),
            daysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysLabel.heightAnchor.constraint(equalToConstant: 50),
            
            daysTextField.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 10),
            daysTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            daysTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        urlLabel.text = "URL сервера"
        maxRecordsLabel.text = "Максимальное количество записей в списках"
        daysLabel.text = "Количество дней по умолчанию между начальной и конечной датами в задаче"
        
        urlTextField.placeholder = "URL"
        maxRecordsTextField.placeholder = "Количество записей"
        daysTextField.placeholder = "Количество дней"
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployee(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func saveEmployee(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
