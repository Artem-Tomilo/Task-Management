import Foundation

/*
 Класс Stub является стаб-реализацией интерфейса сервера
 */
class Stub: Server {
    
    private var employeesArray: [Employee] = []
    
    /*
     Параметр employee - новый сотрудник для добавления в массив и последующего сохранения
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
     Метод удаления сотрудника из массива
     
     parameters:
     id - уникальный id сотрудника, которого необходимо удалить
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    func deleteEmployee(with id: Int, _ completion: @escaping () -> Void) throws {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            self.employeesArray.removeAll(where: { $0.id == id })
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /*
     Метод редактирования сотрудника в массиве
     
     parameters:
     id - уникальный id сотрудника, которого необходимо отредактировать
     newData - отредактированные данные сотрудника
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    func editEmployee(with id: Int, newData: Employee, _ completion: @escaping () -> Void) throws {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            guard let employee = self.employeesArray.first(where: { $0.id == id }) else { return }
            if let index = self.employeesArray.firstIndex(of: employee) {
                self.employeesArray.removeAll(where: { $0.id == id })
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
