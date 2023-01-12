import Foundation

/*
 Сервис для управления загрузками и сохранениями настроек
 */

class SettingsManager {
    
    private let defaultSettingsStorage = DefaultSettingsStorage()
    private let settingsStorage = SettingsStorage()
    
    public init() throws {
        let settings = try self.loadSettings()
        try self.saveUserSettings(settings: settings)
    }
    
    /*
     Метод проверки и загрузки настроек приложения
     */
    private func loadSettings() throws -> Settings {
        do {
            let settings = try settingsStorage.getUserSettings()
            return settings
        } catch {
            let settings = try defaultSettingsStorage.getSettings()
            return settings
        }
    }
    
    /*
     Метод получения сохранных настроек из settingsStorage, в случае отсутствия настроек будет производиться бросание ошибки
     */
    func getSettings() -> Settings {
        do {
            return try settingsStorage.getUserSettings()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /*
     Метод сохранения пользовательских настроек
     */
    func saveUserSettings(settings: Settings) throws {
        try settingsStorage.saveUserSettings(settings: settings)
    }
}
