import Foundation

class Stub: Server {
    
    private var employeesArray: [Employee] = []
    
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.append(employee)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteEmployee(employee: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.removeAll(where: { $0 == employee })
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func editEmployee(employee: Employee, newData: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            if let index = self.employeesArray.firstIndex(of: employee) {
                self.employeesArray.removeAll(where: { $0 == employee })
                self.employeesArray.insert(newData, at: index)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getEmployees() -> [Employee] {
        return employeesArray
    }
}
