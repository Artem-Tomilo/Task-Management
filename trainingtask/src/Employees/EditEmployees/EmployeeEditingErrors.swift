import Foundation

/*
 EmployeeEditingErrors - перечисление возможных ошибок для экрана Редактирование сотрудников
 
 parameters:
 message - текст ошибки, показывающийся в алерте
 */

enum EmployeeEditingErrors: Error {
    case noSurname, noName, noPatronymic, noPostition
    
    var message: String {
        switch self {
        case .noSurname:
            return "Введите фамилию"
        case .noName:
            return "Введите имя"
        case .noPatronymic:
            return "Введите отчество"
        case .noPostition:
            return "Введите должность"
        }
    }
}
