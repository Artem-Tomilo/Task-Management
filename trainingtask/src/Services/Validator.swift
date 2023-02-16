import Foundation

/*
 Класс, осуществляющий проверки текста textField на соответствие нужным значениям
 */
class Validator {
    
    /*
     Метод проверки текста textField на отсутствие значения(пустую строку),
     если значение отсутствует, то будет выбрасываться ошибка
     
     parameters:
     text - проверяемый текст
     message - текст ошибки в случае отсутствия значения
     */
    static func validateTextForMissingValue(text: String, message: String) throws -> String {
        guard text != "" else {
            throw BaseError(message: message)
        }
        return text
    }
    
    /*
     Метод проверки текста textField на соответствие типу Int и возврат этого значения,
     если значение не соответствует, то будет выбрасываться ошибка
     
     parameters:
     text - проверяемый текст
     message - текст ошибки в случае отсутствия значения
     Возвращаемое значение - текст textField в формате Int
     */
    static func validateAndReturnTextForIntValue(text: String, message: String) throws -> Int {
        guard let text = Int(text) else {
            throw BaseError(message: message)
        }
        return text
    }
}
