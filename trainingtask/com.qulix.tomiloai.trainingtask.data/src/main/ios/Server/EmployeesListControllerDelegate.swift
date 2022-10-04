//
//  EmployeesListControllerDelegate.swift
//  trainingtask
//
//  Created by Артем Томило on 3.10.22.
//

import Foundation

protocol EmployeesListControllerDelegate: AnyObject {
    func addEmployee(employee: Employee)
    func deleteEmployee(index: Int)
    func editEmployee(index: Int, newData: Employee)
    func getEmployees() -> [Employee]
}
