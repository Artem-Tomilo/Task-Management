import Foundation

/*
 DefaultSettingsStorage - сервис для получения настроек по умолчанию
 */
class DefaultSettingsStorage {
    
    /*
     Метод получения настроек по умолчанию
     
     Возвращаемое значение Settings - настройки по умолчанию
     Будет производиться обработка ошибочной ситуации в случае неполучения данных
     */
    func getSettings() throws -> Settings {
        guard let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
              let url = settingsDictionary.value(forKey: "Url") as? String,
              let records = settingsDictionary.value(forKey: "Records") as? Int,
              let days = settingsDictionary.value(forKey: "Days") as? Int else {
            throw BaseError(message: "Не удалось получить настройки по умолчанию")
        }
        let defaultSettings = Settings(url: url, maxRecords: records, maxDays: days)
        return defaultSettings
    }
}
