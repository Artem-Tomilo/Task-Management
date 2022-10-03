//
//  StubServer.swift
//  trainingtask
//
//  Created by Артем Томило on 30.09.22.
//

import Foundation

class StubServer: StubServerInterface {
    
    private var employeesArray: [Employee] = []
    
    func addEmployees(employee: Employee) {
        self.employeesArray.append(employee)
    }
    
    func deleteEmployees(index: Int) {
        self.employeesArray.remove(at: index)
    }
    
    func editEmployees(index: Int, newData: Employee) {
        self.employeesArray.remove(at: index)
        self.employeesArray.insert(newData, at: index)
    }
    
    func getEmployees() -> [Employee] {
        return employeesArray
    }
}
