import Foundation

/*
 SettingsStorage - сервис для получения и сохранения настроек пользователя
 */

class SettingsStorage {
    
    private let userDefaults = UserDefaults.standard
    static let settingsKey = "settings" // константа, в которой хранится ключ для UserDefauls, отвечающий за настройки
    
    /*
     Метод, для получения пользовательских настроек
     
     Возращает значение типа Settings? с сохраненными пользовательскими настройками, в случае возникновения ошибок будет производиться их обработка
     */
    func getUserSettings() throws -> Settings {
        guard let data = userDefaults.object(forKey: SettingsStorage.settingsKey) as? Data else {
            throw BaseError(message: "Не удалось получить настройки пользователя")
        }
        let settings = try JSONDecoder().decode(Settings.self, from: data)
        return settings
    }
    
    /*
     Метод для сохранения пользовательских настроек в UserDefaults
     
     parameter:
     settings - объект типа Settings
     */
    func saveUserSettings(settings: Settings) throws {
        guard let data = try? JSONEncoder().encode(settings) else {
            throw BaseError(message: "Не удалось сохранить настройки пользователя")
        }
        userDefaults.set(data, forKey: SettingsStorage.settingsKey)
    }
}
