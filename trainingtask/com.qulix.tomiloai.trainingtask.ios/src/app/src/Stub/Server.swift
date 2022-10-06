import Foundation

protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void)
    func deleteEmployee(employee: Employee, _ completion: @escaping () -> Void)
    func editEmployee(employee: Employee, newData: Employee, _ completion: @escaping () -> Void)
    func getEmployees() -> [Employee]
}
