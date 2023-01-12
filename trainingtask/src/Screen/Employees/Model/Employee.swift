import UIKit

/*
 Структура сотрудника, содержащая поля для заполнения:
 Фамилия, имя, отчество, должность, также содержит уникальный id, который заполняется при создании и полное ФИО
 */

struct Employee: Codable, Equatable {
    var surname: String
    var name: String
    var patronymic: String
    var position: String
    var id: Int
    var fullName: String
    private static var idCounter = 0
    
    init(surname: String, name: String, patronymic: String, position: String) {
        self.surname = surname
        self.name = name
        self.patronymic = patronymic
        self.position = position
        self.fullName = surname + " " + name + " " + patronymic
        self.id = Employee.idCounter
        Employee.idCounter += 1
    }
}
