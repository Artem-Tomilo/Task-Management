import UIKit

/*
 SettingsViewController - экран Настройки, который отображает либо дефолтные, либо пользовательские настройки
 */

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    private var urlView = SettingsInputView()
    private var recordsView = SettingsInputView()
    private var daysView = SettingsInputView()
    private let alertController = Alert()
    
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        displaySettings()
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
        
        recordsView.checkTextFieldForDelegate(flag: true)
        daysView.checkTextFieldForDelegate(flag: true)
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    /*
     Метод для отображения настроек в соответствующих полях, в случае обнаружения ошибок будет производиться их обработка
     */
    private func displaySettings() {
        do {
            let settings = try settingsManager.getSettings()
            
            urlView.bind(labelText: "URL сервера", textFieldPlaceholder: "URL", textFieldText: settings.url)
            recordsView.bind(labelText: "Максимальное количество записей в списках", textFieldPlaceholder: "Количество записей", textFieldText: String(settings.maxRecords))
            daysView.bind(labelText: "Количество дней по умолчанию между начальной и конечной датами в задаче", textFieldPlaceholder: "Количество дней", textFieldText: String(settings.maxDays))
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод сохранения пользовательских настроек, в случае обнаружения ошибок будет производиться их обработка
     */
    private func saveSettings() {
        let newSettings = Settings(url: urlView.unbind(), maxRecords: Int(recordsView.unbind()) ?? 0, maxDays: Int(daysView.unbind()) ?? 0)
        do {
            try settingsManager.saveUserSettings(settings: newSettings)
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let settingsError = error as! SettingsErrors
        alertController.showAlertController(message: settingsError.message, viewController: self)
    }
    
    /*
     Target на кнопку Save - вызывает метод сохранения пользовательских настроек и возвращает на экран Главное меню
     */
    @objc func saveSettings(_ sender: UIBarButtonItem) {
        saveSettings()
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Target на кнопку Cancel - возвращает на экран Главное меню
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
