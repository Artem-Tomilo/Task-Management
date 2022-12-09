import Foundation

/*
 Модель настроек приложения, хранит данные:
 URL сервера, максимальное количество записей в списках, количество дней по умолчанию между начальной и конечной датами в задаче
*/
struct Settings: Codable {
    var url: String
    var maxRecords: Int
    var maxDays: Int
}
