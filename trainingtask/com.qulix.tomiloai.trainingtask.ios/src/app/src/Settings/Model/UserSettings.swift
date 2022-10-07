import Foundation

class UserSettings {
    
    private var userSettings: Settings?
    private var (url, records, days) = ("", "0", "0")
    static let settingsKey = "settings"
    
    private func checkUserSettings() -> Bool {
        if UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) != nil {
            return true
        }
        return false
    }
    
    func getUserSettings() -> Settings? {
        if checkUserSettings() {
            let settings = UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey)
            
            for (key, value) in settings! {
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
                userSettings = Settings(url: url, maxRecords: records, maxDays: days)
                return userSettings
            }
        }
        return nil
    }
    
    func saveUserSettings(url: String, records: String, days: String) {
        var set = [String : Any]()
        set = ["Url" : url, "Records" : records, "Days" : days]
        UserDefaults.standard.setValue(set, forKey: UserSettings.settingsKey)
    }
}
