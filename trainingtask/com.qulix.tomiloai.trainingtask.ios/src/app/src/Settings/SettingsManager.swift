import Foundation

class SettingsManager {
    
    private let defaultSettings = ServiceForGettingDefaultSettings()
    private let userSettings = UserSettingsService()
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
    
    func getSettings() -> Settings? {
        loadSettings()
        return settings ?? nil
    }
}
