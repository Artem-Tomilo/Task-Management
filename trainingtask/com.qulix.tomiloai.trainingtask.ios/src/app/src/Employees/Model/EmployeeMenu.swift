import UIKit

/*
 EmployeeMenu - перечисления параметров сотрудника для отображения в tableView
 
 title - задание русского текста для всех элементов перечисления
 */

enum EmployeeMenu: String, CaseIterable {
    case Surname, Name, Patronymic, Position
    
    var title: String {
        switch self {
        case .Surname:
            return "Фамилия"
        case .Name:
            return "Имя"
        case .Patronymic:
            return "Отчество"
        case .Position:
            return "Должность"
        }
    }
}
