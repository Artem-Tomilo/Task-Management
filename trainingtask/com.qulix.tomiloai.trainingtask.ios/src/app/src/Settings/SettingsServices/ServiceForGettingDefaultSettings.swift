import Foundation

/*
 ServiceForGettingDefaultSettings - сервис для получения настроек по умолчанию
 */
class ServiceForGettingDefaultSettings {
    
    /*
     getDefaultSettings - метод получения настроек по умолчанию
     
     Возвращаемое значение Settings - настройки по умолчанию
     Будет производиться обработка ошибочной ситуации в случае неполучения данных
     */
    func getDefaultSettings() throws -> Settings {
        if let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
           let url = settingsDictionary.value(forKey: "Url") as? String,
           let records = settingsDictionary.value(forKey: "Records") as? Int,
           let days = settingsDictionary.value(forKey: "Days") as? Int {
            let defaultSettings = Settings(url: url, maxRecords: records, maxDays: days)
            return defaultSettings
        }
        return Settings(url: "", maxRecords: 0, maxDays: 0)
    }
}
