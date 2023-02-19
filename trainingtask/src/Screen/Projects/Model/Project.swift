import Foundation

/**
 Структура модели Проекта
 */
struct Project: Codable, Equatable {
    
    /**
     Название проекта
     */
    var name: String
    
    /**
     Описание проекта
     */
    var description: String
    
    /**
     Уникальный id проекта, который назначается на сервере
     */
    var id: Int
    
    /**
     Инициализатор структуры
     
     - parameters:
        - name: название проекта
        - description: описание проекта
        - id: уникальный id
     */
    init(name: String, description: String, id: Int) {
        self.name = name
        self.description = description
        self.id = id
    }
}
