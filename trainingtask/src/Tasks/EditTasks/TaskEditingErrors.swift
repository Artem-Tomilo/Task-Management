//
//  TaskEditingErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import Foundation

enum TaskEditingErrors: Error {
    case noName, noProject, noEmployee, noStatus, noRequiredNumberOfHours, wrongHours, noStartDate, noEndDate
    
    var message: String {
        switch self {
        case .noName:
            return "Введите название"
        case .noProject:
            return "Выберите проект"
        case .noEmployee:
            return "Выберите сотрудника"
        case .noStatus:
            return "Выберите статус"
        case .noRequiredNumberOfHours:
            return "Введите количество часов для выполнения задачи"
        case .wrongHours:
            return "Количество часов не может быть равным 0"
        case .noStartDate:
            return "Выберите начальную дату"
        case .noEndDate:
            return "Выберите конечную дату"
        }
    }
}

