import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    private var urlView = SettingsCustomView()
    private var recordsView = SettingsCustomView()
    private var daysView = SettingsCustomView()
    
    private let defaultsSettings = DefaultSettings()
    private let userSettings = UserSettings()
    private var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadSettings()
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
    
    func loadSettings() {
        do {
            if userSettings.checkUserSettings() {
                if let userSettings =  try userSettings.getUserSettings() {
                    settings = userSettings
                }
            } else {
                let defaultsSettings =  try defaultsSettings.getDefaultsSetiings()
                settings = defaultsSettings
            }
        } catch {
            print(error.localizedDescription)
        }
        showSettings()
    }
    
    private func showSettings() {
        urlView.setTextFieldText(text: settings?.url ?? "")
        recordsView.setTextFieldText(text: settings?.maxRecords ?? "0")
        daysView.setTextFieldText(text: settings?.maxDays ?? "0")
    }
    
    @objc func saveSettings(_ sender: UIBarButtonItem) {
        do {
            try userSettings.saveUserSettings(url: urlView.getTextFieldText(), records: recordsView.getTextFieldText(), days: daysView.getTextFieldText())
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
