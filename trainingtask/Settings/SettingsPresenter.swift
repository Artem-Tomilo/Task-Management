//
//  SettingsPresenter.swift
//  trainingtask
//
//  Created by Артем Томило on 28.09.22.
//

import Foundation

protocol SettingsPresenterOutputs: AnyObject {
    func showSettings(url: String, records: String, days: String)
}

protocol SettingsPresenterInputs: AnyObject {
    init(view: SettingsPresenterOutputs)
    func urlTextChanged(_ newUrl: String)
    func recordsTextChanged(_ newRecords: String)
    func daysTextChanged(_ newDays: String)
    func getData()
    func saveSettings()
}

class SettingsPresenter: SettingsPresenterInputs {
    
    private var urlText = ""
    private var recordsText = ""
    private var daysText = ""
    private let userDefaults = UserDefaults.standard
    static let settingsKey = "settings"
    
    let viewController: SettingsPresenterOutputs
    
    required init(view: SettingsPresenterOutputs) {
        self.viewController = view
    }
    
    func userSettingsExist() -> Bool {
        if UserDefaults.standard.dictionary(forKey: SettingsPresenter.settingsKey) != nil {
            return true
        }
        return false
    }
    
    func getData() {
        if userSettingsExist() {
            guard let settings = UserDefaults.standard.dictionary(forKey: SettingsPresenter.settingsKey) else { return }
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
        self.viewController.showSettings(url: urlText, records: recordsText, days: daysText)
    }
    
    func urlTextChanged(_ newUrl: String) {
        urlText = newUrl
    }
    
    func recordsTextChanged(_ newRecords: String) {
        recordsText = newRecords
    }
    
    func daysTextChanged(_ newDays: String) {
        daysText = newDays
    }
    
    func saveSettings() {
        if urlText != " " ||
            urlText != "" ||
            recordsText != "0" ||
            recordsText != "" ||
            daysText != "0" ||
            daysText != "" {
            var set = [String : Any]()
            set = ["Url" : urlText, "Records" : recordsText, "Days" : daysText]
            UserDefaults.standard.setValue(set, forKey: SettingsPresenter.settingsKey)
        }
    }
}
