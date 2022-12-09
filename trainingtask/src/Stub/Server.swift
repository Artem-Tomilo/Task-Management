import Foundation

/*
 Protocol Server - интерфейс взаимодействия с сервером
 */
protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) throws
    func deleteEmployee(id: Int, _ completion: @escaping () -> Void) throws
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping () -> Void) throws
    func getEmployees(_ completion: @escaping ([Employee]) -> Void)
}
