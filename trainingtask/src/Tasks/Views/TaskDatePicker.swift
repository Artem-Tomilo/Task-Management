import UIKit

/*
 TaskDatePicker - класс наследник UIDatePicker с дополнительными свойствами и методами
 */

class TaskDatePicker: UIDatePicker {
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private var textField = BorderedTextField()
    private let dateFormatter = TaskDateFormatter()
    private var keyboardButton = UIBarButtonItem()
    private var keyboardIsActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let size = toolbar.sizeThatFits(CGSize(width: bounds.width, height: 0))
        toolbar.frame.size = size
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        keyboardButton = UIBarButtonItem(title: "Keyboard", style: .done, target: self, action: #selector(keyboardButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([keyboardButton, flexSpace, doneButton], animated: false)
    }
    
    /*
     Метод получения данных из DatePicker и прявязки их в textField
     */
    private func getDataFromPicker() {
        if !keyboardIsActive {
            let stringDatePickerDate = dateFormatter.string(from: datePicker.date)
            textField.text = stringDatePickerDate
        }
    }
    
    /*
     Метод отображения datePicker
     
     parameters:
     textField - textField, который вызывает этот метод
     */
    func showDatePicker(textField: BorderedTextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.becomeFirstResponder()
        textField.tintColor = .clear
        self.textField = textField
    }
    
    /*
     Метод смены клавиатуры на календарь и обратно для ввода даты
     */
    private func changeInputView() {
        textField.resignFirstResponder()
        textField.text?.removeAll()
        if !keyboardIsActive {
            textField.inputView = nil
            textField.placeholder = "yyyy-MM-dd"
            keyboardIsActive = true
            keyboardButton.title = "Сalendar"
        } else {
            textField.inputView = datePicker
            keyboardIsActive = false
            keyboardButton.title = "Keyboard"
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
}
