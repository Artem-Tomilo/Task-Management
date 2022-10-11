import Foundation

class SettingsManager {
    
    private let defaultSettings = DefaultSettings()
    private let userSettings = UserSettings()
    private var settings: Settings?
    
    /*
     loadSettings - метод проверки и загрузки настроек приложения
     
     В случает возникновения ошибок производится их обработка
     */
    private func loadSettings() {
        do {
            if let userSettings =  try userSettings.getUserSettings() {
                settings = userSettings
            } else {
                let defaultSettings =  try defaultSettings.getDefaultSettings()
                settings = defaultSettings
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
     saveUserSettings - метод для сохранения пользовательских настроек в UserDefaults
     
     parameter:
     settings - объект типа Settings
     */
    func saveUserSettings(settings: Settings) throws {
        var set = [String : Any]()
        set = ["Url" : settings.url, "Records" : settings.maxRecords, "Days" : settings.maxDays]
        UserDefaults.standard.setValue(set, forKey: UserSettings.settingsKey)
    }
    
    func getSettings() -> Settings? {
        loadSettings()
        return settings ?? nil
    }
}
