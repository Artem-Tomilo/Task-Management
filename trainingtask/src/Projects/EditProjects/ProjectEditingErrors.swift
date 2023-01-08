import Foundation

/*
 ProjectEditingErrors - перечисление возможных ошибок для экрана Редактирование проекта
 
 parameters:
 message - текст ошибки, показывающийся в алерте
 */

enum ProjectEditingErrors: Error {
    case noName, noDescription
    
    var message: String {
        switch self {
        case .noName:
            return "Введите название"
        case .noDescription:
            return "Введите описание"
        }
    }
}
