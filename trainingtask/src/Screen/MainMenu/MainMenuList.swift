import UIKit

/**
 Перечисление названий экранов, на которые можно перейти из Главного меню
 */
enum MainMenuList: String, CaseIterable {
    
    /**
     Проекты
     */
    case projects
    
    /**
     Задачи
     */
    case tasks
    
    /**
     Сотрудники
     */
    case employees
    
    /**
     Настройки
     */
    case settings
}
