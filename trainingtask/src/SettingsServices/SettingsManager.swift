import Foundation

/*
 Сервис для управления загрузками и сохранениями настроек
 */
class SettingsManager {
    
    private static let settingsLoader = SettingsLoader()
    private static let settingsStorage = SettingsStorage()
    
    private var settings: Settings
    
    public init() throws {
        self.settings = try Self.loadSettings()
        try self.saveUserSettings(settings: settings)
    }
    
    /*
     Метод проверки и загрузки настроек приложения
     */
    private static func loadSettings() throws -> Settings {
        do {
            return try Self.settingsStorage.getUserSettings()
        } catch {
            guard let defaultSettingsPath = Bundle.main.path(forResource: "Settings", ofType: ".plist") else {
                throw BaseError(message: "Не удалось получить настройки по умолчанию")
            }
            return try Self.settingsLoader.loadSettings(path: defaultSettingsPath)
        }
    }
    
    /*
     Метод получения сохранных настроек из settingsStorage,
     в случае ошибки происходит ее обработка
     */
    func getSettings() -> Settings {
        return settings
    }
    
    /*
     Метод сохранения пользовательских настроек
     */
    func saveUserSettings(settings: Settings) throws {
        try Self.settingsStorage.saveUserSettings(settings: settings)
        self.settings = settings
    }
}
