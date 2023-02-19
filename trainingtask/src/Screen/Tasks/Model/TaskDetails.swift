import Foundation

/**
 Редактируемая модель задачи для передачи данных на сервер
 */
struct TaskDetails {
    
    /**
     Название задачи
     */
    var name: String
    
    /**
     Проект, которому принадлежит задача
     */
    var project: Project
    
    /**
     Сотрудник, исполняющий задачу
     */
    var employee: Employee
    
    /**
     Статус задачи
     */
    var status: TaskStatus
    
    /**
     Требуемое количество часов для выполнения
     */
    var requiredNumberOfHours: Int
    
    /**
     Дата начала задачи
     */
    var startDate: Date
    
    /**
     Дата окончания задачи
     */
    var endDate: Date
}
