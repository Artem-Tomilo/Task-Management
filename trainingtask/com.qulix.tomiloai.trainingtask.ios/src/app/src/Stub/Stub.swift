import Foundation

/*
 Класс Stub является стаб-реализацией интерфейса сервера
 */

class Stub: Server {
    
    private var employeesArray: [Employee] = []
    
    /*
     Параметр employee - новый сотрудник для в массив и последующего сохранения
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.append(employee)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /*
     Параметр employee - сотрудник, которого необходимо удалить
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    
    func deleteEmployee(employee: Employee, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.removeAll(where: { $0 == employee })
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /*
     Параметр employee - сотрудник, которого необходимо отредактировать
     Параметр newData - отредактированный сотрудник
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    
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
    
    func getEmployees() -> [Employee] {   // возвращаемое значение является массивом всех сотрудников, который хранится на сервере
        return employeesArray
    }
}
