import Foundation

/*
 SettingsStorage - сервис для хранения, выгрузки, сохранения настроек
 */
class SettingsStorage {
    
    private var settings: Settings!
    
    /*
     метод для выгрузки сохраненных настроек
     */
    func loadSettings() -> Settings {
        return settings!
    }
    
    /*
     метод для сохранения текущих настроек
     
     parameters:
     settings - настройки, которые нужно сохранить
     */
    func saveSettings(settings: Settings) {
        self.settings = settings
    }
}
