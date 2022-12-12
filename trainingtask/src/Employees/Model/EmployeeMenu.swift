import UIKit

/*
 EmployeeMenu - перечисления параметров сотрудника для отображения в tableView
 
 title - задание русского текста для всех элементов перечисления
 */

enum EmployeeMenu: String, CaseIterable {
    case surname, name, patronymic, position
    
    var title: String {
        switch self {
        case .surname:
            return "Фамилия"
        case .name:
            return "Имя"
        case .patronymic:
            return "Отчество"
        case .position:
            return "Должность"
        }
    }
}
