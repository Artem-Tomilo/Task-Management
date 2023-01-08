import Foundation

/*
 SettingsErrors - перечисление возможных ошибок для экрана Настройки
 
 parameters:
 message - текст ошибки, показывающийся в алерте
 */

enum SettingsErrors: Error {
    case noDefaultSettings, noUserSettings, saveUserSettingsError
    
    var message: String {
        switch self {
        case .noDefaultSettings:
            return "Не удалось получить настройки по умолчанию"
        case .noUserSettings:
            return "Не удалось получить настройки пользователя"
        case .saveUserSettingsError:
            return "Не удалось сохранить настройки пользователя"
        }
    }
}
