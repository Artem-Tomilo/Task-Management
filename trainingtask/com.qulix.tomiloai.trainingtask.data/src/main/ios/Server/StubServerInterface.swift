//
//  StubServerInterface.swift
//  trainingtask
//
//  Created by Артем Томило on 3.10.22.
//

import Foundation

protocol StubServerInterface: AnyObject {
    func addEmployees(employee: Employee)
    func deleteEmployees(index: Int)
    func editEmployees(index: Int, newData: Employee)
    func getEmployees() -> [Employee]
}
