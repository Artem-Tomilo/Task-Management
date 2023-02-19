import Foundation

/**
 Сервис для управления загрузками и сохранениями настроек
 */
class SettingsManager {
    
    private static let settingsLoader = SettingsLoader()
    private static let settingsStorage = SettingsStorage()
    
    private var settings: Settings
    
    public init() throws {
        self.settings = try Self.loadSettings()
    }
    
    /**
     Метод проверки и загрузки настроек приложения, в случае возникновения ошибок происходит их обработка
     
     - returns:
        Настройки, который будут загружены
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
    
    /**
     Метод получения сохранных настроек
     
     - returns:
        Сохраненные настройки
     */
    func getSettings() -> Settings {
        return settings
    }
    
    /**
     Метод сохранения пользовательских настроек, в случае ошибки происходит ее обработка
     
     - parameters:
        - settings: настройки, которые необходимо сохранить
     */
    func saveUserSettings(settings: Settings) throws {
        try Self.settingsStorage.saveUserSettings(settings: settings)
        self.settings = settings
    }
}
