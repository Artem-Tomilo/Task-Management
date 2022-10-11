import Foundation

/*
 UserSettings - сервис для получения и сохранения настроек пользователя
 */
class UserSettings {
    
    private var userSettings: Settings?
    private var (url, records, days) = ("","","")
    static let settingsKey = "settings" // константа, в которой хранится ключ для UserDefauls, отвечающий за настройки
    
    /*
     getUserSettings - метод, для получения пользовательских настроек
     
     Возращает значение типа Settings? с сохраненными пользовательскими настройками, в случае возникновения ошибок будет производиться их обработка
     */
    func getUserSettings() throws -> Settings? {
        guard let settings = UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) else { return nil }
        for (key, value) in settings {
            switch key {
            case "Url":
                url = value as! String
            case "Records":
                records = value as! String
            case "Days":
                days = value as! String
            default:
                break
            }
        }
        userSettings = Settings(url: url, maxRecords: String(records), maxDays: String(days))
        return userSettings
    }
}
