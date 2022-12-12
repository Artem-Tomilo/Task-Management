//
//  Task.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

struct Task: Equatable {
    let name: String
    let project: Project
    let employee: Employee
    let status: TaskStatus
    let requiredNumberOfHours: Int
    let startDate: Date
    let endDate: Date
    let id: Int
    private static var idCounter = 0
    
    init(name: String, project: Project, employee: Employee, status: TaskStatus, requiredNumberOfHours: Int, startDate: Date, endDate: Date) {
        self.name = name
        self.project = project
        self.employee = employee
        self.status = status
        self.requiredNumberOfHours = requiredNumberOfHours
        self.startDate = startDate
        self.endDate = endDate
        self.id = Task.idCounter
        Task.idCounter += 1
    }
}
