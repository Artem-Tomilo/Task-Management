import Foundation

/**
 Структура для заполнения полей ячейки TaskCell
 */
struct TaskCellItem {
    
    /**
     Название задачи
     */
    let name: String
    
    /**
     Название проекта, которому принадлежит задача
     */
    let project: String
    
    /**
     Статус задачи
     */
    let status: TaskStatus
}
