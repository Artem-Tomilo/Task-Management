//
//  SettingsErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 3.01.23.
//

import Foundation

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
