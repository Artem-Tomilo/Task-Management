import Foundation

/*
 SettingsStorage - сервис для получения и сохранения настроек пользователя
 */
class SettingsStorage {
    
    private let userDefaults = UserDefaults.standard
    static let settingsKey = "settings" // константа, в которой хранится ключ для UserDefauls, отвечающий за настройки
    
    /*
     getUserSettings - метод, для получения пользовательских настроек
     
     Возращает значение типа Settings? с сохраненными пользовательскими настройками, в случае возникновения ошибок будет производиться их обработка
     */
    func getUserSettings() throws -> Settings? {
        guard let data = userDefaults.object(forKey: SettingsStorage.settingsKey) as? Data else { return nil }
        let settings = try JSONDecoder().decode(Settings.self, from: data)
        return settings
    }
    
    /*
     saveUserSettings - метод для сохранения пользовательских настроек в UserDefaults
     
     parameter:
     settings - объект типа Settings
     */
    func saveUserSettings(settings: Settings) throws {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        userDefaults.set(data, forKey: SettingsStorage.settingsKey)
    }
}
