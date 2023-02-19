import UIKit

/**
 Перечисление возможных статусов для задачи
 */
enum TaskStatus: String, CaseIterable {
    
    /**
     Не начата
     */
    case notStarted
    
    /**
     В процессе
     */
    case inProgress
    
    /**
     Завершена
     */
    case completed
    
    /**
     Отложена
     */
    case postponed
}
