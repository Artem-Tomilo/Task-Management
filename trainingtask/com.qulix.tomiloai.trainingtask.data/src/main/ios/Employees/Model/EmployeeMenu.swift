//
//  EmployeeMenu.swift
//  trainingtask
//
//  Created by Артем Томило on 28.09.22.
//

import UIKit

enum EmployeeMenu: String, CaseIterable {
    case Surname, Name, Patronymic, Position
    
    var title: String {
        switch self {
        case .Surname:
            return "Фамилия"
        case .Name:
            return "Имя"
        case .Patronymic:
            return "Отчество"
        case .Position:
            return "Должность"
        }
    }
}
