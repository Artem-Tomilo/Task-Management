import Foundation

/*
 Протокол EmployeeEditViewControllerDelegate - интерфейс для взаимодействия с экраном Список сотрудников
 */

protocol EmployeeEditViewControllerDelegate: AnyObject {
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController)
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee)
    func editEmployee(_ controller: EmployeeEditViewController, editedEmployee: Employee)
}
