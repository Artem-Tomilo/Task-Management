//
//  ModelBuilder.swift
//  trainingtask
//
//  Created by Артем Томило on 23.09.22.
//

import UIKit

protocol Builder {
    func createModule() -> UIViewController
}

class ModelBuilder: Builder {
    func createModule() -> UIViewController {
        let repository = EmployeeRepository()
        let view = EmployeesListViewController()
        let presenter = EmployeePresenter(view: view, repository: repository)
        view.presenter = presenter
        return view
    }
    
    func createSettings() -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
