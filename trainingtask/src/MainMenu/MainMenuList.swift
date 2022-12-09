import UIKit

/*
 MainMenuList - перечисление названий экранов, на которые можно перейти из Главного меню
 
 title - задание русского текста для всех элементов перечисления
 */

enum MainMenuList: String, CaseIterable {
    case Projects, Tasks, Employees, Settings
    
    var title: String {
        switch self {
        case .Projects:
            return "Проекты"
        case .Tasks:
            return "Задачи"
        case .Employees:
            return "Сотрудники"
        case .Settings:
            return "Настройки"
        }
    }
}
