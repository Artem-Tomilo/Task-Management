import UIKit

class TaskHoursTextField: BorderedTextField, UITextFieldDelegate {
    
    override init(placeholder: String) {
        super.init(placeholder: placeholder)
        keyboardType = .numberPad
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Метод получения текста requiredNumberOfHoursTextField, его проверки и форматирования в числовой формат,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - числовое значение текста requiredNumberOfHoursTextField
     */
    private func taskHoursValidation() throws -> Int {
        let text = try Validator.validateTextForMissingValue(text: unbind(),
                                                             message: "Введите количество часов для выполнения задачи")
        
        let hours = try Validator.validateAndReturnTextForIntValue(text: text,
                                                                   message: "Введено некорректное количество часов")
        guard hours > 0 else {
            throw BaseError(message: "Количество часов должно быть больше 0")
        }
        return hours
    }
    
    func unbindIntValue() throws -> Int {
        return try taskHoursValidation()
    }
    
    /*
     Метод UITextFieldDelegate для проверки вводимых данных
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
}
