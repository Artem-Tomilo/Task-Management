//
//  EmployeeListErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import Foundation

enum EmployeeStubErrors: Error {
    case noSuchEmployee, editEmployeeFailed, deleteEmployeeFailed
    
    var message: String {
        switch self {
        case .noSuchEmployee:
            return "Не удалось получить сотрудника"
        case .editEmployeeFailed:
            return "Не удалось отредактировать сотрудника"
        case .deleteEmployeeFailed:
            return "Не удалось удалить сотрудника"
        }
    }
}
