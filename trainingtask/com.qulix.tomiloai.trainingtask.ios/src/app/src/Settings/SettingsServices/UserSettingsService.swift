import Foundation

/*
 UserSettingsService - сервис для получения и сохранения настроек пользователя
 */
class UserSettingsService {
    
    private var (url, records, days) = ("",0,0)
    static let settingsKey = "settings" // константа, в которой хранится ключ для UserDefauls, отвечающий за настройки
    
    /*
     getUserSettings - метод, для получения пользовательских настроек
     
     Возращает значение типа Settings? с сохраненными пользовательскими настройками, в случае возникновения ошибок будет производиться их обработка
     */
    func getUserSettings() throws -> Settings? {
        guard let settings = UserDefaults.standard.dictionary(forKey: UserSettingsService.settingsKey) else { return nil }
        for (key, value) in settings {
            switch key {
            case "Url":
                url = value as! String
            case "Records":
                records = value as! Int
            case "Days":
                days = value as! Int
            default:
                break
            }
        }
        let userSettings = Settings(url: url, maxRecords: records, maxDays: days)
        return userSettings
    }
    
    /*
     saveUserSettings - метод для сохранения пользовательских настроек в UserDefaults
     
     parameter:
     settings - объект типа Settings
     */
    func saveUserSettings(settings: Settings) throws {
        var set = [String : Any]()
        set = ["Url" : settings.url, "Records" : settings.maxRecords, "Days" : settings.maxDays]
        UserDefaults.standard.setValue(set, forKey: UserSettingsService.settingsKey)
    }
}
