import Foundation

/*
 Protocol Server - интерфейс взаимодействия с сервером
 */

protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) throws
    func deleteEmployee(employee: Employee, _ completion: @escaping () -> Void) throws
    func editEmployee(employee: Employee, newData: Employee, _ completion: @escaping () -> Void) throws
    func getEmployees() -> [Employee]
}
