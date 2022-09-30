//
//  EmployeePresenter.swift
//  trainingtask
//
//  Created by Артем Томило on 23.09.22.
//

import Foundation

protocol EmployeePresenterInputs: AnyObject {
    func saveEmployee(to array: [Employee])
    func loadEmployees() -> [Employee]
}

class EmployeePresenter: EmployeePresenterInputs {
    
    weak var viewController: EmployeesListViewController?
    let repository: EmployeeRepository
    
    init(view: EmployeesListViewController, repository: EmployeeRepository) {
        self.viewController = view
        self.repository = repository
        view.presenter = self
    }
    
    func saveEmployee(to array: [Employee]) {
        let new = array
        repository.saveEmployee(to: new)
    }
    
    func loadEmployees() -> [Employee] {
        var newArray = [Employee]()
        newArray = repository.loadEmployees()
        return newArray
    }
}
