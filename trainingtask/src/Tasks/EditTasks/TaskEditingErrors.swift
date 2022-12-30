//
//  TaskEditingErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import Foundation

enum TaskEditingErrors: Error {
    case noName, noProject, noEmployee, noStatus, noRequiredNumberOfHours, wrongHours, noStartDate, noEndDate, noSuchStatus, wrongStartDate, wrongEndDate
    
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
            return "Введено некорректное количество часов"
        case .noStartDate:
            return "Выберите начальную дату"
        case .noEndDate:
            return "Выберите конечную дату"
        case .noSuchStatus:
            return "Не удалось выбрать статус"
        case .wrongStartDate:
            return "Некоректный ввод начальной даты"
        case .wrongEndDate:
            return "Некоректный ввод конечной даты"
        }
    }
}

