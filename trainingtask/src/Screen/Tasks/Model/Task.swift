import UIKit

/*
 Структура задачи, содержащая поля для заполнения:
 Название, проект, ответственный сотдуник, статус, колчиство часов для выполнения, дата начала выполнения, дата окончания выполнения также содержит уникальный id, который заполняется при создании
 */

struct Task: Equatable {
    var name: String
    var project: Project
    var employee: Employee
    var status: TaskStatus
    var requiredNumberOfHours: Int
    var startDate: Date
    var endDate: Date
    var id: Int
    private static var idCounter = 0
    
    init(name: String, project: Project, employee: Employee, status: TaskStatus, requiredNumberOfHours: Int, startDate: Date, endDate: Date) {
        self.name = name
        self.project = project
        self.employee = employee
        self.status = status
        self.requiredNumberOfHours = requiredNumberOfHours
        self.startDate = startDate
        self.endDate = endDate
        self.id = Task.idCounter
        Task.idCounter += 1
    }
}
