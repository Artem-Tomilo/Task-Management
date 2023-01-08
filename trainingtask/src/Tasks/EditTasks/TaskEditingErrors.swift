import Foundation

/*
 TaskEditingErrors - перечисление возможных ошибок для экрана Редактирование задачи
 
 parameters:
 message - текст ошибки, показывающийся в алерте
 */

enum TaskEditingErrors: Error {
    case noName, noProject, noEmployee, noStatus, noRequiredNumberOfHours, wrongHours, noStartDate, noEndDate, noSuchStatus, wrongStartDate, wrongEndDate, startDateGreaterEndDate
    
    var message: String {
        switch self {
        case .noName:
            return "Введите название"
        case .noProject:
            return "Выберите проект"
        case .noEmployee:
            return "Выберите сотрудника"
        case .noStatus:
            return "Выберите статус"
        case .noRequiredNumberOfHours:
            return "Введите количество часов для выполнения задачи"
        case .wrongHours:
            return "Введено некорректное количество часов"
        case .noStartDate:
            return "Выберите начальную дату"
        case .noEndDate:
            return "Выберите конечную дату"
        case .noSuchStatus:
            return "Не удалось выбрать статус"
        case .wrongStartDate:
            return "Некоректный ввод начальной даты"
        case .wrongEndDate:
            return "Некоректный ввод конечной даты"
        case .startDateGreaterEndDate:
            return "Начальная дата не должна быть больше конечной даты"
        }
    }
}

