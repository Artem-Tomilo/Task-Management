import Foundation

class UserSettings {
    
    private var userSettings: Settings?
    private var (url, records, days) = ("","","")
    static let settingsKey = "settings"
    
    func checkUserSettings() -> Bool {
        if UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) != nil {
            return true
        }
        return false
    }
    
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
    
    func saveUserSettings(url: String, records: String, days: String) throws {
        var set = [String : Any]()
        set = ["Url" : url, "Records" : records, "Days" : days]
        UserDefaults.standard.setValue(set, forKey: UserSettings.settingsKey)
    }
}
