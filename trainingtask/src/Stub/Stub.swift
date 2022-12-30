import Foundation

/*
 Класс Stub является стаб-реализацией интерфейса сервера
 */
class Stub: Server {
    
    private var employeesArray: [Employee] = []
    private var projectsArray: [Project] = []
    private var tasksArray: [Task] = []
    
    init() {
        createProjects()
        createEmployees()
        createTasks()
    }
    
    private func createProjects() {
        let projectsNames = ["GYM", "English", "Prostore", "BMW"]
        let descriptions = ["Тренажерный зал", "Английский язык", "Магазин", "Авто"]
        
        for i in 0..<4 {
            let project = Project(name: projectsNames[i], description: descriptions[i])
            projectsArray.append(project)
        }
    }
    
    private func createEmployees() {
        let lastNames = ["Томило", "Свиридов", "Котов", "Бобров"]
        let firstNames = ["Артем", "Сергей", "Максим", "Виталий"]
        let patronymics = ["Игоревич", "Александрович", "Владимирович", "Юрьевич"]
        let postiton = ["разработчик", "директор", "бухгалтер", "охранник"]
        
        for i in 0..<4 {
            let employee = Employee(surname: lastNames[i], name: firstNames[i], patronymic: patronymics[i], position: postiton[i])
            employeesArray.append(employee)
        }
    }
    
    private func createTasks() {
        let tasks = ["Становая тяга", "Бег", "Выучить новые слова", "Повторить правило", "Купить продукты", "Купить воды", "Заправить авто", "Помыть авто"]
        var count = 0
        
        for i in 0..<4 {
            for _ in 0..<2 {
                let task = Task(name: tasks[count], project: projectsArray[i], employee: employeesArray[i], status: TaskStatus.allCases[i], requiredNumberOfHours: 3, startDate: Date(), endDate: Date())
                tasksArray.append(task)
                count += 1
            }
        }
    }
    
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
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) throws {
        employeesArray.append(employee)
        guard employeesArray.contains(where: { $0 == employee }) else {
            throw EmployeeStubErrors.addEmployeeFailed
        }
        delay() {
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
        guard let employee = self.employeesArray.first(where: { $0.id == id }) else {
            throw EmployeeStubErrors.deleteEmployeeFailed
        }
        employeesArray.removeAll(where: { $0 == employee })
        delay() {
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
        guard let employee = self.employeesArray.first(where: { $0.id == id }) else {
            throw EmployeeStubErrors.editEmployeeFailed
        }
        if let index = self.employeesArray.firstIndex(of: employee) {
            self.employeesArray.removeAll(where: { $0.id == id })
            self.employeesArray.insert(editedEmployee, at: index)
        } else {
            throw EmployeeStubErrors.noSuchEmployee
        }
        delay() {
            completion()
        }
    }
    
    /*
     Метод отправления массива сотрудников
     
     parameters:
     completion - блок, в котором передается массив сотрудников
     */
    func getEmployees(_ completion: @escaping ([Employee]) -> Void) {
        delay() {
            completion(self.employeesArray)
        }
    }
    
    func addProject(project: Project, _ completion: @escaping () -> Void) throws {
        projectsArray.append(project)
        guard projectsArray.contains(where: { $0 == project }) else {
            throw ProjectStubErrors.addProjectFailed
        }
        delay() {
            completion()
        }
    }
    
    func deleteProject(id: Int, _ completion: @escaping () -> Void) throws {
        guard let project = self.projectsArray.first(where: { $0.id == id }) else {
            throw ProjectStubErrors.deleteProjectFailed
        }
        projectsArray.removeAll(where: { $0 == project })
        delay() {
            completion()
        }
    }
    
    func editProject(id: Int, editedProject: Project, _ completion: @escaping () -> Void) throws {
        guard let project = self.projectsArray.first(where: { $0.id == id }) else {
            throw ProjectStubErrors.editProjectFailed
        }
        if let index = self.projectsArray.firstIndex(of: project) {
            self.projectsArray.removeAll(where: { $0.id == id })
            self.projectsArray.insert(editedProject, at: index)
        } else {
            throw ProjectStubErrors.noSuchProject
        }
        delay() {
            completion()
        }
    }
    
    func getProjects(_ completion: @escaping ([Project]) -> Void) {
        delay() {
            completion(self.projectsArray)
        }
    }
    
    func addTask(task: Task, _ completion: @escaping () -> Void) throws {
        tasksArray.append(task)
        guard tasksArray.contains(where: { $0 == task }) else {
            throw TaskStubErrors.addTaskFailed
        }
        delay() {
            completion()
        }
    }
    
    func deleteTask(id: Int, _ completion: @escaping () -> Void) throws {
        guard let task = self.tasksArray.first(where: { $0.id == id }) else {
            throw TaskStubErrors.deleteTaskFailed
        }
        tasksArray.removeAll(where: { $0 == task })
        delay() {
            completion()
        }
    }
    
    func editTask(id: Int, editedTask: Task, _ completion: @escaping () -> Void) throws {
        guard let task = self.tasksArray.first(where: { $0.id == id }) else {
            throw TaskStubErrors.editTaskFailed
        }
        if let index = self.tasksArray.firstIndex(of: task) {
            self.tasksArray.removeAll(where: { $0.id == id })
            self.tasksArray.insert(editedTask, at: index)
        } else {
            throw TaskStubErrors.noSuchTask
        }
        delay() {
            completion()
        }
    }
    
    func getTasks(_ completion: @escaping ([Task]) -> Void) {
        delay() {
            completion(self.tasksArray)
        }
    }
    
    func getTasksFor(project: Project, _ completion: @escaping ([Task]) -> Void) throws {
        var tasksForProject = [Task]()
        if let project = projectsArray.first(where: { $0 == project }) {
            tasksForProject = self.tasksArray.filter({ $0.project == project })
        } else {
            throw TaskStubErrors.noTaskList
        }
        delay() {
            completion(tasksForProject)
        }
    }
}
