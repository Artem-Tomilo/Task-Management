//
//  EditEmployeeErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import Foundation

enum EmployeeEditingErrors: Error {
    case noSurname, noName, noPatronymic, noPostition
    
    var message: String {
        switch self {
        case .noSurname:
            return "Введите фамилию"
        case .noName:
            return "Введите имя"
        case .noPatronymic:
            return "Введите отчество"
        case .noPostition:
            return "Введите должность"
        }
    }
}
