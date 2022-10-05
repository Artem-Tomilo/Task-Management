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
    
    func deleteEmployee(index: Int, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.remove(at: index)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func editEmployee(index: Int, newData: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.remove(at: index)
            self.employeesArray.insert(newData, at: index)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getEmployees() -> [Employee] {
        return employeesArray
    }
}
