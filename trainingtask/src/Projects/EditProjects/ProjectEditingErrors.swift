//
//  ProjectEditingErrors.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import Foundation

enum ProjectEditingErrors: Error {
    case noName, noDescription
    
    var message: String {
        switch self {
        case .noName:
            return "Введите название"
        case .noDescription:
            return "Введите описание"
        }
    }
}
