import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    private var urlView = SettingsCustomView()
    private var recordsView = SettingsCustomView()
    private var daysView = SettingsCustomView()
    
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

        view.addSubview(urlView)
        view.addSubview(recordsView)
        view.addSubview(daysView)
        
        NSLayoutConstraint.activate([
            urlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            urlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            urlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            recordsView.topAnchor.constraint(equalTo: urlView.bottomAnchor, constant: 50),
            recordsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            daysView.topAnchor.constraint(equalTo: recordsView.bottomAnchor, constant: 50),
            daysView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        urlView.addLabelText(text: "URL сервера")
        recordsView.addLabelText(text: "Максимальное количество записей в списках")
        daysView.addLabelText(text: "Количество дней по умолчанию между начальной и конечной датами в задаче")
        
        urlView.addTextFieldPlaceholder(text: "URL")
        recordsView.addTextFieldPlaceholder(text: "Количество записей")
        daysView.addTextFieldPlaceholder(text: "Количество дней")
        
        recordsView.checkTextFieldForDelegate(flag: true)
        daysView.checkTextFieldForDelegate(flag: true)
        
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
        
    }
    
    private func saveSettings() {
        var set = [String : Any]()
//        set = ["Url" : urlText, "Records" : recordsText, "Days" : daysText]
        UserDefaults.standard.setValue(set, forKey: SettingsViewController.settingsKey)
    }
    
    @objc func saveSettings(_ sender: UIBarButtonItem) {
//        urlText = urlTextField.text ?? ""
//        recordsText = maxRecordsTextField.text ?? "0"
//        daysText = daysTextField.text ?? "0"
        saveSettings()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
