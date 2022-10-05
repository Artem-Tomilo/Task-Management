import Foundation

protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void)
    func deleteEmployee(index: Int, _ completion: @escaping () -> Void)
    func editEmployee(index: Int, newData: Employee, _ completion: @escaping () -> Void)
    func getEmployees() -> [Employee]
}
