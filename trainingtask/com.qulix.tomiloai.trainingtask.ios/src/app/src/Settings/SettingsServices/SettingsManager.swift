import Foundation

/*
 Сервис для управления загрузками и сохранениями настроек
 */
class SettingsManager {
    
    private let defaultSettingsService = ServiceForGettingDefaultSettings()
    private let userSettingsService = UserSettingsService()
    private let settingsStorage = SettingsStorage()
    
    /*
     checkingSavedSettings - метод проверки и загрузки настроек приложения
     
     В случает возникновения ошибок производится их обработка
     */
    private func checkingSavedSettings() { //checking saved settings
        do {
            if let userSettings =  try userSettingsService.getUserSettings() {
                settingsStorage.saveSettings(settings: userSettings)
            } else {
                let defaultSettings =  try defaultSettingsService.getDefaultSettings()
                settingsStorage.saveSettings(settings: defaultSettings)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
     Метод получения сохранных настроек из settingsStorage
     */
    func getSettings() -> Settings {
        checkingSavedSettings()
        return settingsStorage.loadSettings()
    }
    
    /*
     Метод сохранения пользовательских настроек
     */
    func saveUserSettings(settings: Settings) throws {
        userSettingsService.saveUserSettings(settings: settings)
    }
}
