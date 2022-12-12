//
//  TaskStatus.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

enum TaskStatus: String, CaseIterable {
    case notStarted, inProgress, completed, postponed
    
    var title: String {
        switch self {
        case .notStarted:
            return "Не начата"
        case .inProgress:
            return "В процессе"
        case .completed:
            return "Завершена"
        case .postponed:
            return "Отложена"
        }
    }
}
