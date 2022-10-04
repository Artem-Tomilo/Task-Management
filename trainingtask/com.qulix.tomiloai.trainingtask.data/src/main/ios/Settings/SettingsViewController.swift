//
//  SettingsViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 27.09.22.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    private var urlLabel = SettingsLabel()
    private var urlTextField = CustomTextField()
    private var maxRecordsLabel = SettingsLabel()
    private var maxRecordsTextField = CustomTextField()
    private var daysLabel = SettingsLabel()
    private var daysTextField = CustomTextField()
    
    private var urlText = ""
    private var recordsText = ""
    private var daysText = ""
    private let userDefaults = UserDefaults.standard
    static let settingsKey = "settings"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }
    
    private func setup() {
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
        
        maxRecordsTextField.delegate = self
        daysTextField.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func userSettingsExist() -> Bool {
        if UserDefaults.standard.dictionary(forKey: SettingsViewController.settingsKey) != nil {
            return true
        }
        return false
    }
    
    private func getData() {
        if userSettingsExist() {
            guard let settings = UserDefaults.standard.dictionary(forKey: SettingsViewController.settingsKey) else { return }
            for (key, value) in settings {
                switch key {
                case "Url":
                    urlText = value as! String
                case "Records":
                    recordsText = value as! String
                case "Days":
                    daysText = value as! String
                default:
                    break
                }
            }
        } else {
            guard let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
                  let dictionary = NSDictionary(contentsOfFile: path),
                  let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
                  let url = settingsDictionary.value(forKey: "Url") as? String,
                  let records = settingsDictionary.value(forKey: "Records") as? Int,
                  let days = settingsDictionary.value(forKey: "Days") as? Int else { return }
            urlText = url
            recordsText = String(records)
            daysText = String(days)
        }
        showSettings(url: urlText, records: recordsText, days: daysText)
    }
    
    private func showSettings(url: String, records: String, days: String) {
        urlTextField.text = url
        maxRecordsTextField.text = records
        daysTextField.text = days
    }
    
    private func saveSettings() {
        var set = [String : Any]()
        set = ["Url" : urlText, "Records" : recordsText, "Days" : daysText]
        UserDefaults.standard.setValue(set, forKey: SettingsViewController.settingsKey)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
    
    @objc func saveSettings(_ sender: UIBarButtonItem) {
        urlText = urlTextField.text ?? ""
        recordsText = maxRecordsTextField.text ?? "0"
        daysText = daysTextField.text ?? "0"
        saveSettings()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
