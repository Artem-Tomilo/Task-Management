import Foundation

/*
 UserSettings - сервис для получения и сохранения настроек пользователя
 */

class UserSettings {
    
    private var userSettings: Settings?
    private var (url, records, days) = ("","","")
    static let settingsKey = "settings" // константа, в которой хранится ключ для UserDefauls, отвечающий за настройки
    
    /*
     checkUserSettings - метод проверки пользовательских настроек, сохраненных в UserDefaults
     
     Возвращаемое значение будет равно true, если настройки сохранены и false, если настроек нет
     */
    func checkUserSettings() -> Bool {
        if UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) != nil {
            return true
        }
        return false
    }
    
    /*
     getUserSettings - метод, для получения пользовательских настроек
     
     Возращаемое значение типа Settings? будет передано и сохранено для отображения на экране Настройки, в случае возникновения ошибок будет производиться их обработка
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
    
    /*
     saveUserSettings - метож для сохранения пользовательских настроек в UserDefaults
     
     Параметры url, records, days - передаются в словарь, который будет сохранен, в случае возникновения ошибок будет производиться их обработка
     */
    
    func saveUserSettings(url: String, records: String, days: String) throws {
        var set = [String : Any]()
        set = ["Url" : url, "Records" : records, "Days" : days]
        UserDefaults.standard.setValue(set, forKey: UserSettings.settingsKey)
    }
}
