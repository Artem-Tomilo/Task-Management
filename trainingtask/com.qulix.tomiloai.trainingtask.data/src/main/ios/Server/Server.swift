//
//  Server.swift
//  trainingtask
//
//  Created by Артем Томило on 30.09.22.
//

import Foundation

class Server: EmployeesListControllerDelegate {
    
    private var employeesArray: [Employee] = []
    
    func addEmployee(employee: Employee) {
        self.employeesArray.append(employee)
    }
    
    func deleteEmployee(index: Int) {
        self.employeesArray.remove(at: index)
    }
    
    func editEmployee(index: Int, newData: Employee) {
        self.employeesArray.remove(at: index)
        self.employeesArray.insert(newData, at: index)
    }
    
    func getEmployees() -> [Employee] {
        return employeesArray
    }
}
