import UIKit

/*
 MainMenuList - перечисление названий экранов, на которые можно перейти из Главного меню
 
 title - задание русского текста для всех элементов перечисления
 */

enum MainMenuList: String, CaseIterable {
    case projects, tasks, employees, settings
    
    var title: String {
        switch self {
        case .projects:
            return "Проекты"
        case .tasks:
            return "Задачи"
        case .employees:
            return "Сотрудники"
        case .settings:
            return "Настройки"
        }
    }
}
