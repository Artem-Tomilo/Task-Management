import Foundation

/*
 Класс Stub является стаб-реализацией интерфейса сервера
 */
class Stub: Server {
    
    private var employeesArray: [Employee] = []
    
    /*
     Метод создает макет для асинхронного вызова нужных методов
     
     parameters:
     completion - completion блок, который вызывается на главном потоке
     */
    private func delay(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /*
     Метод добавления нового сотрудника в массив
     
     parameters:
     employee - новый сотрудник для добавления в массив и последующего сохранения
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) {
        employeesArray.append(employee)
        delay {
            completion()
        }
    }
    
    /*
     Метод удаления сотрудника из массива
     
     parameters:
     id - уникальный id сотрудника, которого необходимо удалить
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    func deleteEmployee(id: Int, _ completion: @escaping () -> Void) throws {
        employeesArray.removeAll(where: { $0.id == id })
        delay {
            completion()
        }
    }
    
    /*
     Метод редактирования сотрудника в массиве
     
     parameters:
     id - уникальный id сотрудника, которого необходимо отредактировать
     editedEmployee - отредактированные данные сотрудника
     completion - отдельный блок, который будет выполняться на главном потоке
     */
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping () -> Void) throws {
        guard let employee = self.employeesArray.first(where: { $0.id == id }) else { return }
        if let index = self.employeesArray.firstIndex(of: employee) {
            self.employeesArray.removeAll(where: { $0.id == id })
            self.employeesArray.insert(editedEmployee, at: index)
        }
        delay {
            completion()
        }
    }
    
    /*
     Метод отправления массива сотрудников
     
     parameters:
     completion - блок, в котором передается массив сотрудников
     */
    func getEmployees(_ completion: @escaping ([Employee]) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                completion(self.employeesArray)
            }
        }
    }
}
