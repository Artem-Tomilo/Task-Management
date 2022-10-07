import Foundation

class DefaultSettings {
    
    private var defaultsSettings: Settings?
    
    func getDefaultsSetiings() -> Settings? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
           let url = settingsDictionary.value(forKey: "Url") as? String,
           let records = settingsDictionary.value(forKey: "Records") as? String,
           let days = settingsDictionary.value(forKey: "Days") as? String {
            defaultsSettings = Settings(url: url, maxRecords: records, maxDays: days)
            return defaultsSettings
        }
        return nil
    }
}
