import Foundation

/**
 Cервис для загрузки настроек
 */
class SettingsLoader {
    
    /**
     Метод загрузки настроек по заданному пути, будет производиться обработка ошибочной ситуации в случае неполучения данных
     
     - parameters:
        - path: путь, по которому будут загружаться настройки
     
     - returns:
        Загруженные настройки
     */
    func loadSettings(path: String) throws -> Settings {
        guard let dictionary = NSDictionary(contentsOfFile: path),
              let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
              let url = settingsDictionary.value(forKey: "Url") as? String,
              let records = settingsDictionary.value(forKey: "Records") as? Int,
              let days = settingsDictionary.value(forKey: "Days") as? Int else {
            throw BaseError(message: "Не удалось получить настройки по умолчанию")
        }
        let settings = Settings(url: url, maxRecords: records, maxDays: days)
        return settings
    }
}
