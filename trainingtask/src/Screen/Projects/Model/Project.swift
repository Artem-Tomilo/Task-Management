import Foundation

/*
 Структура проекта, содержащая поля для заполнения:
 Название, описание, также содержит уникальный id, который заполняется при создании
 */
struct Project: Codable, Equatable {
    var name: String
    var description: String
    var id: Int
    private static var idCounter = 0
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
        self.id = Project.idCounter
        Project.idCounter += 1
    }
}
