import Foundation

/**
 Сервис для получения и сохранения настроек пользователя
 */
class SettingsStorage {
    
    private let userDefaults = UserDefaults.standard
    
    /**
     Значение, в котором хранится ключ для UserDefauls, отвечающий за настройки
     */
    private static let settingsKey = "settings"
    
    /**
     Метод  для получения пользовательских настроек, в случае возникновения ошибок будет производиться их обработка
     
     - returns:
        Сохраненные настройки пользователя
     */
    func getUserSettings() throws -> Settings {
        guard let data = userDefaults.object(forKey: SettingsStorage.settingsKey) as? Data else {
            throw BaseError(message: "Не удалось получить настройки пользователя")
        }
        let settings = try JSONDecoder().decode(Settings.self, from: data)
        return settings
    }
    
    /**
     Метод для сохранения пользовательских настроек в UserDefaults, в случае возникновения ошибок будет производиться их обработка
     
     - parameters:
        - settings: настройки для сохранения
     */
    func saveUserSettings(settings: Settings) throws {
        guard let data = try? JSONEncoder().encode(settings) else {
            throw BaseError(message: "Не удалось сохранить настройки пользователя")
        }
        userDefaults.set(data, forKey: SettingsStorage.settingsKey)
    }
}
