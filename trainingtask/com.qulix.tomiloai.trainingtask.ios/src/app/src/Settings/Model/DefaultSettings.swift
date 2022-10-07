import Foundation

/*
 DefaultSettings - сервис для получения настроек по умолчанию
 */

class DefaultSettings {
    
    private var defaultsSettings: Settings?
    
    /*
     getDefaultsSetiings - метод получения настроек по умолчанию
     
     Возвращаемое значение Settings? - настройки по умолчанию, которые будут отображаться на экране Настройки, значение опционально, т.к. оно может не прийти и возникнет ошибка
     
     Будет производиться обработка ошибочной ситуации в случае неполучения данных
     */
    
    func getDefaultsSetiings() throws -> Settings? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
           let url = settingsDictionary.value(forKey: "Url") as? String,
           let records = settingsDictionary.value(forKey: "Records") as? Int,
           let days = settingsDictionary.value(forKey: "Days") as? Int {
            defaultsSettings = Settings(url: url, maxRecords: String(records), maxDays: String(days))
            return defaultsSettings
        }
        return nil
    }
}
