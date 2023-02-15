import UIKit

/*
 DatePickerView - view для выбора даты
 */

class DatePickerView: UIView, UITextFieldDelegate {
    
    let textField = BorderedTextField(placeholder: "yyyy-MM-dd")
    let dateFormatter = DateFormatter()
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private var keyboardButton = UIBarButtonItem()
    private var keyboardIsActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        showDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        textField.keyboardType = .numberPad
        textField.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let size = CGSize(width: 320, height: 44)
        toolbar.frame.size = size
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed(_:)))
        keyboardButton = UIBarButtonItem(title: "Keyboard",
                                         style: .done,
                                         target: self,
                                         action: #selector(keyboardButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([keyboardButton, flexSpace, doneButton], animated: false)
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    /*
     Метод присвоения текста для textField
     
     parameters:
     date - дата для отображения в textField
     */
    func bind(_ date: Date) {
        let stringDate = dateFormatter.string(from: date)
        textField.bind(stringDate)
    }
    
    /*
     Метод получения текста textField, его проверки и форматирования в формат даты,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - начальная дата
     */
    func unbind() throws -> Date {
        let text = try Validator.validateTextForMissingValue(text: textField.unbind(),
                                                             message: "Введите начальную дату")
        if let date = dateFormatter.date(from: text) {
            return date
        } else {
            throw BaseError(message: "Некоректный ввод начальной даты")
        }
    }
    
    /*
     Метод получения данных из DatePicker и прявязки их в textField
     */
    private func getDataFromPicker() {
        if !keyboardIsActive {
            let stringDatePickerDate = dateFormatter.string(from: datePicker.date)
            textField.bind(stringDatePickerDate)
        }
    }
    
    /*
     Метод отображения datePicker
     */
    private func showDatePicker() {
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.tintColor = .clear
        keyboardIsActive = false
        keyboardButton.title = "Keyboard"
    }
    
    /*
     Метод отображения клавиатуры
     */
    private func showKeyboard() {
        textField.inputView = nil
        keyboardIsActive = true
        keyboardButton.title = "Сalendar"
    }
    
    /*
     Метод смены клавиатуры на календарь и обратно для ввода даты
     */
    private func changeInputView() {
        textField.resignFirstResponder()
        if !keyboardIsActive {
            showKeyboard()
        } else {
            showDatePicker()
        }
        textField.becomeFirstResponder()
    }
    
    /*
     Target на кнопку Done - вызывает привязку данных для textField
     */
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        getDataFromPicker()
        textField.endEditing(false)
    }
    
    /*
     Target на кнопку Keyboard - вызывает смену вводимого поля
     */
    @objc func keyboardButtonPressed(_ sender: UIBarButtonItem) {
        changeInputView()
    }
    
    /*
     Метод для создания маски при вводе даты с клавиатуры
     
     parameters:
     date - текст textField
     */
    private func formatDate(date: String) -> String {
        let cleanDate = date.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXX-XX-XX"
        var result = ""
        var index = cleanDate.startIndex
        
        for ch in mask where index < cleanDate.endIndex {
            if ch == "X" {
                result.append(cleanDate[index])
                index = cleanDate.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /*
     Метод UITextFieldDelegate для проверки вводимых даннх
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatDate(date: newString)
        return false
    }
}
