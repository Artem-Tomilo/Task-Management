import UIKit

/**
 Структура модели Задачи
 */
struct Task: Equatable {
    
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
     Количество часов, требуемое для выполнения задачи
     */
    var requiredNumberOfHours: Int
    
    /**
     Дата наала задачи
     */
    var startDate: Date
    
    /**
     Дата окончания задачи
     */
    var endDate: Date
    
    /**
     Уникальный id задачи, который назначается на сервере
     */
    var id: Int
    
    /**
     Инициализатор структуры
     
     - parameters:
        - name: название задачи
        - project: проект, которому принадлежит задача
        - employee: сотрудник, исполняющий задачу
        - prostatusject: описание проекта
        - requiredNumberOfHours: количество часов, требуемое для выполнения задачи
        - startDate: дата наала задачи
        - endDate: дата окончания задачи
        - id: уникальный id
     */
    init(name: String, project: Project, employee: Employee, status: TaskStatus,
         requiredNumberOfHours: Int, startDate: Date, endDate: Date, id: Int) {
        self.name = name
        self.project = project
        self.employee = employee
        self.status = status
        self.requiredNumberOfHours = requiredNumberOfHours
        self.startDate = startDate
        self.endDate = endDate
        self.id = id
    }
}
