import Foundation

/*
 Protocol Server - интерфейс взаимодействия с сервером
 */
protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) throws
    func deleteEmployee(with id: Int, _ completion: @escaping () -> Void) throws
    func editEmployee(with id: Int, newData: Employee, _ completion: @escaping () -> Void) throws
    func getEmployees() -> [Employee]
}
