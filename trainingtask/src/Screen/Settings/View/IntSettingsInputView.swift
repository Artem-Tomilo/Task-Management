import UIKit

/*
 View для отображения и заполнения данных в числовом формате на экране настройки
 */
class IntSettingsInputView: SettingsInputView {
    
    override init(textField: BorderedTextField, labelText: String) {
        super.init(textField: textField, labelText: labelText)
        self.setTextFieldDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Метод получения текста textField, его проверки на отсутствие значения и форматирования в числовой формат,
     в случае ошибки происходит ее обработка
     
     parameters:
     missingValueErrorMessage - сообщение для алерта в случае отсутствия значения
     intValueErrorMessage - сообщение для алерта в случае ошибки конвертации значения в числовой формат
     
     Возвращаемое значение - числовое значение текста textField
     */
    func validateValue(missingValueErrorMessage: String,
                       intValueErrorMessage: String) throws -> Int {
        let text = try Validator.validateTextForMissingValue(text: unbind(),
                                                             message: missingValueErrorMessage)
        return try Validator.validateAndReturnTextForIntValue(text: text,
                                                              message: intValueErrorMessage)
    }
    
    /*
     Метод перевода Int значения в String и привязки в textField
     
     parametrs:
     value - данные для заполнения textField в формате Int
     */
    func bindIntValue(_ value: Int) {
        let text = String(value)
        bind(text)
    }
    
    /*
     Метод UITextFieldDelegate для проверки вводимых данных на соответствие числовому формату
     */
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
}
