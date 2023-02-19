import Foundation

/**
 Модель настроек приложения
 */
struct Settings: Codable {
    /**
     URL сервера
     */
    var url: String
    
    /**
     Максимальное количество записей в списках
     */
    var maxRecords: Int
    
    /**
     Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    var maxDays: Int
}
