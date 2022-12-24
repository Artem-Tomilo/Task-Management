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
    
    func addProject(project: Project, _ completion: @escaping () -> Void) {
        projectsArray.append(project)
        delay {
            completion()
        }
    }
    
    func deleteProject(id: Int, _ completion: @escaping () -> Void) throws {
        projectsArray.removeAll(where: { $0.id == id })
        delay {
            completion()
        }
    }
    
    func editProject(id: Int, editedProject: Project, _ completion: @escaping () -> Void) throws {
        guard let project = self.projectsArray.first(where: { $0.id == id }) else { return }
        if let index = self.projectsArray.firstIndex(of: project) {
            self.projectsArray.removeAll(where: { $0.id == id })
            self.projectsArray.insert(editedProject, at: index)
        }
        delay {
            completion()
        }
    }
    
    func getProjects(_ completion: @escaping ([Project]) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                completion(self.projectsArray)
            }
        }
    }
    
    func addTask(task: Task, _ completion: @escaping () -> Void) {
        tasksArray.append(task)
        delay {
            completion()
        }
    }
    
    func deleteTask(id: Int, _ completion: @escaping () -> Void) throws {
        tasksArray.removeAll(where: { $0.id == id })
        delay {
            completion()
        }
    }
    
    func editTask(id: Int, editedTask: Task, _ completion: @escaping () -> Void) throws {
        guard let task = self.tasksArray.first(where: { $0.id == id }) else { return }
        if let index = self.tasksArray.firstIndex(of: task) {
            self.tasksArray.removeAll(where: { $0.id == id })
            self.tasksArray.insert(editedTask, at: index)
        }
        delay {
            completion()
        }
    }
    
    func getTasks(_ completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                completion(self.tasksArray)
            }
        }
    }
    
    func getTasksFor(project: Project, _ completion: @escaping ([Task]) -> Void) {
        var tasksForProject = [Task]()
        if let project = projectsArray.first(where: { $0 == project }) {
            tasksForProject = self.tasksArray.filter({ $0.project == project })
        }
        delay {
            completion(tasksForProject)
        }
    }
}
