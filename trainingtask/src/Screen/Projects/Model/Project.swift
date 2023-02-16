import Foundation

/*
 Структура проекта, содержащая поля для заполнения:
 Название, описание, также содержит уникальный id, который заполняется при создании
 */
struct Project: Codable, Equatable {
    var name: String
    var description: String
    var id: Int
    
    init(name: String, description: String, id: Int) {
        self.name = name
        self.description = description
        self.id = id
    }
}
