import Foundation

/**
 Класс  является стаб-реализацией интерфейса сервера
 */
class Stub: Server {
    
    private var employeesArray: [Employee] = []
    private var projectsArray: [Project] = []
    private var tasksArray: [Task] = []
    
    private var employeeIdCounter = 0
    private var projectIdCounter = 0
    private var taskIdCounter = 0
    
    init() {
        createProjects()
        createEmployees()
        createTasks()
    }
    
    private func createProjects() {
        let projectsNames = ["GYM", "English", "Prostore", "BMW"]
        let descriptions = ["Тренажерный зал", "Английский язык", "Магазин", "Авто"]
        
        for i in 0..<4 {
            let project = Project(name: projectsNames[i], description: descriptions[i], id: projectIdCounter)
            projectsArray.append(project)
            projectIdCounter += 1
        }
    }
    
    private func createEmployees() {
        let lastNames = ["Томило", "Свиридов", "Котов", "Бобров"]
        let firstNames = ["Артем", "Сергей", "Максим", "Виталий"]
        let patronymics = ["Игоревич", "Иванович", "Сергеевич", "Юрьевич"]
        let postiton = ["разработчик", "директор", "бухгалтер", "охранник"]
        
        for i in 0..<4 {
            let employee = Employee(surname: lastNames[i],
                                    name: firstNames[i],
                                    patronymic: patronymics[i],
                                    position: postiton[i],
                                    id: employeeIdCounter)
            employeesArray.append(employee)
            employeeIdCounter += 1
        }
    }
    
    private func createTasks() {
        let tasks = ["Становая тяга", "Бег", "Выучить новые слова", "Повторить правило",
                     "Купить продукты", "Купить воды", "Заправить авто", "Помыть авто"]
        var count = 0
        
        for i in 0..<4 {
            for _ in 0..<2 {
                let task = Task(name: tasks[count], project: projectsArray[i],
                                employee: employeesArray[i], status: TaskStatus.allCases[i],
                                requiredNumberOfHours: 3, startDate: Date(), endDate: Date(), id: taskIdCounter)
                tasksArray.append(task)
                taskIdCounter += 1
                count += 1
            }
        }
    }
    
    /**
     Метод создает требуемую задержку в 1 сек на глобальном потоке и переходит на главный поток
     
     - parameters:
        - completion: блок, который вызывается на главном потоке после требуемой задержки
     */
    private func delay(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /**
     Метод добавления нового сотрудника в массив
     
     - parameters:
        - employeeDetails: модель сотрудника для добавления в массив и последующего сохранения на сервере
        - completion: блок, который будет выполняться на главном потоке
     */
    func addEmployee(employeeDetails: EmployeeDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            let newEmployee = Employee(surname: employeeDetails.surname,
                                       name: employeeDetails.name,
                                       patronymic: employeeDetails.patronymic,
                                       position: employeeDetails.position,
                                       id: self.employeeIdCounter)
            self.employeesArray.append(newEmployee)
            self.employeeIdCounter += 1
            if self.employeesArray.contains(where: { $0 == newEmployee }) {
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось добавить сотрудника")))
            }
        }
    }
    
    /**
     Метод удаления сотрудника из массива
     
     - parameters:
        - id: уникальный id сотрудника, которого необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteEmployee(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let employee = self.employeesArray.first(where: { $0.id == id }) {
                self.employeesArray.removeAll(where: { $0 == employee })
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось удалить сотрудника")))
            }
        }
    }
    
    /**
     Метод редактирования сотрудника в массиве
     
     - parameters:
        - id: уникальный id сотрудника, которого необходимо отредактировать
        - editedEmployee: отредактированные данные сотрудника
        - completion: блок, который будет выполняться на главном потоке
     */
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let employee = self.employeesArray.first(where: { $0.id == id }) {
                if let index = self.employeesArray.firstIndex(of: employee) {
                    self.employeesArray.removeAll(where: { $0.id == id })
                    self.employeesArray.insert(editedEmployee, at: index)
                } else {
                    completion(.failure(BaseError(message: "Не удалось отредактировать сотрудника")))
                }
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось получить сотрудника")))
            }
        }
    }
    
    /**
     Метод получения массива сотрудников с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив сотрудников, либо ошибка
     */
    func getEmployees(_ completion: @escaping (Result<[Employee], BaseError>) -> Void) {
        delay() {
            if self.employeesArray.count > 0 {
                completion(.success(self.employeesArray))
            } else {
                completion(.failure(BaseError(message: "Отсутствуют сохраненные сотрудники")))
            }
        }
    }
    
    /**
     Метод добавления нового проекта в массив
     
     - parameters:
        - projectDetails: модель проекта для добавления в массив и последующего сохранения
        - completion: блок, который будет выполняться на главном потоке
     */
    func addProject(projectDetails: ProjectDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            let newProject = Project(name: projectDetails.name,
                                     description: projectDetails.description,
                                     id: self.projectIdCounter)
            self.projectsArray.append(newProject)
            self.projectIdCounter += 1
            if self.projectsArray.contains(where: { $0 == newProject }) {
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось добавить проект")))
            }
        }
    }
    
    /**
     Метод удаления проекта из массива
     
     - parameters:
        - id: уникальный id проекта, который необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteProject(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let project = self.projectsArray.first(where: { $0.id == id }) {
                self.projectsArray.removeAll(where: { $0 == project })
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось удалить проект")))
            }
        }
    }
    
    /**
     Метод редактирования проекта в массиве
     
     - parameters:
        - id: уникальный id проекта, который необходимо отредактировать
        - editedProject: отредактированные данные проекта
        - completion: блок, который будет выполняться на главном потоке
     */
    func editProject(id: Int, editedProject: Project, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let project = self.projectsArray.first(where: { $0.id == id }) {
                if let index = self.projectsArray.firstIndex(of: project) {
                    self.projectsArray.removeAll(where: { $0.id == id })
                    self.projectsArray.insert(editedProject, at: index)
                } else {
                    completion(.failure(BaseError(message: "Не удалось отредактировать проект")))
                }
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось получить проект")))
            }
        }
    }
    
    /**
     Метод получения массива проектов с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив проектов, либо ошибка
     */
    func getProjects(_ completion: @escaping (Result<[Project], BaseError>) -> Void) {
        delay() {
            if self.projectsArray.count > 0 {
                completion(.success(self.projectsArray))
            } else {
                completion(.failure(BaseError(message: "Отсутствуют сохраненные проекты")))
            }
        }
    }
    
    /**
     Метод добавления новой задачи в массив
     
     - parameters:
        - taskDetails: модель задачи для добавления в массив и последующего сохранения
        - completion: блок, который будет выполняться на главном потоке
     */
    func addTask(taskDetails: TaskDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            let newTask = Task(name: taskDetails.name,
                               project: taskDetails.project,
                               employee: taskDetails.employee,
                               status: taskDetails.status,
                               requiredNumberOfHours: taskDetails.requiredNumberOfHours,
                               startDate: taskDetails.startDate,
                               endDate: taskDetails.endDate,
                               id: self.taskIdCounter)
            self.tasksArray.append(newTask)
            self.taskIdCounter += 1
            if self.tasksArray.contains(where: { $0 == newTask }) {
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось добавить задачу")))
                
            }
        }
    }
    
    /**
     Метод удаления задачи из массива
     
     - parameters:
        - id: уникальный id задачи, которую необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteTask(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let task = self.tasksArray.first(where: { $0.id == id }) {
                self.tasksArray.removeAll(where: { $0 == task })
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось удалить задачу")))
            }
        }
    }
    
    /**
     Метод редактирования задачи в массиве
     
     - parameters:
        - id: уникальный id задачи, которую необходимо отредактировать
        - editedTask: отредактированные данные задачи
        - completion: блок, который будет выполняться на главном потоке
     */
    func editTask(id: Int, editedTask: Task, _ completion: @escaping (Result<Void, BaseError>) -> Void) {
        delay() {
            if let task = self.tasksArray.first(where: { $0.id == id }) {
                if let index = self.tasksArray.firstIndex(of: task) {
                    self.tasksArray.removeAll(where: { $0.id == id })
                    self.tasksArray.insert(editedTask, at: index)
                } else {
                    completion(.failure(BaseError(message: "Не удалось отредактировать задачу")))
                }
                completion(.success(()))
            } else {
                completion(.failure(BaseError(message: "Не удалось получить задачу")))
            }
        }
    }
    
    /**
     Метод получения массива задач с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив задач, либо ошибка
     */
    func getTasks(_ completion: @escaping (Result<[Task], BaseError>) -> Void) {
        delay() {
            if self.tasksArray.count > 0 {
                completion(.success(self.tasksArray))
            } else {
                completion(.failure(BaseError(message: "Отсутствуют сохраненные задачи")))
            }
        }
    }
    
    /**
     Метод получения массива задач для определенного проекта с сервера
     
     - parameters:
        - project: проект, для которого необходимо получить задачи
        - completion: блок, в котором происходит обработка запроса,
    в случае успеха передается массив задач, в случае неудачи обработка ошибки
     */
    func getTasksFor(project: Project, _ completion: @escaping (Result<[Task], BaseError>) -> Void) {
        delay() {
            var tasksForProject = [Task]()
            if let project = self.projectsArray.first(where: { $0 == project }) {
                tasksForProject = self.tasksArray.filter({ $0.project == project })
            } else {
                completion(.failure(BaseError(message: "Не удалось получить список задач")))
            }
            completion(.success(tasksForProject))
        }
    }
}
