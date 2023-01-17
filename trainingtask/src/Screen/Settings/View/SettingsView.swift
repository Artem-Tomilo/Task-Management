import UIKit

/*
 SettingsInputView - view для отображения на экране Настройки
 */

class SettingsView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let urlLabel = BorderedLabel()
    private let urlTextField = BorderedTextField(placeholder: "URL")
    private let recordsLabel = BorderedLabel()
    private let recordsTextField = BorderedTextField(placeholder: "Количество записей")
    private let daysLabel = BorderedLabel()
    private let daysTextField = BorderedTextField(placeholder: "Количество дней")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(urlLabel)
        addSubview(urlTextField)
        addSubview(recordsLabel)
        addSubview(recordsTextField)
        addSubview(daysLabel)
        addSubview(daysTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            urlLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            urlLabel.heightAnchor.constraint(equalToConstant: 50),
            
            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10),
            urlTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            urlTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            recordsLabel.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 50),
            recordsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            recordsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            recordsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            recordsTextField.topAnchor.constraint(equalTo: recordsLabel.bottomAnchor, constant: 10),
            recordsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            recordsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            daysLabel.topAnchor.constraint(equalTo: recordsTextField.bottomAnchor, constant: 50),
            daysLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            daysLabel.heightAnchor.constraint(equalToConstant: 50),
            
            daysTextField.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 10),
            daysTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            daysTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        urlLabel.textColor = .white
        urlLabel.font = UIFont.boldSystemFont(ofSize: 16)
        urlLabel.backgroundColor = .systemRed
        
        recordsLabel.textColor = .white
        recordsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        recordsLabel.backgroundColor = .systemRed
        
        daysLabel.textColor = .white
        daysLabel.font = UIFont.boldSystemFont(ofSize: 16)
        daysLabel.backgroundColor = .systemRed
        
        urlTextField.delegate = self
        recordsTextField.delegate = self
        daysTextField.delegate = self
        
        recordsTextField.keyboardType = .numberPad
        daysTextField.keyboardType = .numberPad
        
        urlLabel.bindText("URL сервера")
        recordsLabel.bindText("Максимальное количество записей в списках")
        daysLabel.bindText("Количество дней по умолчанию между начальной и конечной датами в задаче")
    }
    
    /*
     Метод вызова FirstResponder при загрузке view
     */
    func initFirstResponder() {
        urlTextField.becomeFirstResponder()
    }
    
    /*
     Метод для заполнения текущего view данными
     
     parametrs:
     urlTextFieldText - данные для поля urlTextFieldText
     recordsTextFieldText - данные для поля recordsTextFieldText
     daysTextFieldText- данные для поля daysTextFieldText
     */
    func bind(urlTextFieldText: String, recordsTextFieldText: String, daysTextFieldText: String) {
        urlTextField.bindText(urlTextFieldText)
        recordsTextField.bindText(recordsTextFieldText)
        daysTextField.bindText(daysTextFieldText)
    }
    
    /*
     Метод для проверки и получения текста urlTextField'а
     
     Возвращаемое значение - сам текст
     */
    func unbindUrl() -> String {
        return urlTextField.unbindText()
    }
    
    /*
     Метод получения текста recordsTextField, его проверки и форматирования в числовой формат,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - числовое значение текста recordsTextField
     */
    func unbindRecords() throws -> Int {
        let text = try Validator.validateTextForMissingValue(text: recordsTextField.unbindText(),
                                                             message: "Введите количество записей")
        return try Validator.validateAndReturnTextForIntValue(text: text,
                                                              message: "Введено некорректное количество записей")
    }
    
    /*
     Метод получения текста daysTextField, его проверки и форматирования в числовой формат,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - числовое значение текста daysTextField
     */
    func unbindDays() throws -> Int {
        let text = try Validator.validateTextForMissingValue(text: daysTextField.unbindText(),
                                                             message: "Введите количество дней")
        return try Validator.validateAndReturnTextForIntValue(text: text,
                                                              message: "Введено некорректное количество дней")
    }
    
    /*
     Метод UITextFieldDelegate для проверки вводимых даннх
     */
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == recordsTextField || textField == daysTextField {
            return string.allSatisfy {
                $0.isNumber
            }
        }
        return true
    }
    
    /*
     Метод UIGestureRecognizerDelegate
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
