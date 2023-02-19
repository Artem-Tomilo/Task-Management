import UIKit

/**
 Структура модели Сотрудника
 */
struct Employee: Codable, Equatable {
    
    /**
     Фамилия сотрудника
     */
    var surname: String
    
    /**
     Имя сотрудника
     */
    var name: String
    
    /**
     Отчество сотрудника
     */
    var patronymic: String
    
    /**
     Должность сотрудника
     */
    var position: String
    
    /**
     Уникальный id сотрудника, который назначается на сервере
     */
    var id: Int
    
    /**
     Полное ФИО сотрудника
     */
    var fullName: String
    
    /**
     Инициализатор структуры
     
     - parameters:
        - surname: фамилия
        - name: имя
        - patronymic: отчество
        - position: должность
        - id: уникальный id
     */
    init(surname: String, name: String, patronymic: String, position: String, id: Int) {
        self.surname = surname
        self.name = name
        self.patronymic = patronymic
        self.position = position
        self.id = id
        self.fullName = surname + " " + name + " " + patronymic
    }
}
