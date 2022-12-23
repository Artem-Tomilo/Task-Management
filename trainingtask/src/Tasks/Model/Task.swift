//
//  Task.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

struct Task: Equatable {
    var name: String
    var project: Project
    var employee: Employee
    var status: TaskStatus
    var requiredNumberOfHours: Int
    var startDate: Date
    var endDate: Date
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
