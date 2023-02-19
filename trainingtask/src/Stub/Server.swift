import Foundation

/**
 Интерфейс взаимодействия с сервером
 */
protocol Server: AnyObject {
    
    /**
     Метод добавления нового сотрудника в массив
     
     - parameters:
        - employeeDetails: модель сотрудника для добавления в массив и последующего сохранения на сервере
        - completion: блок, который будет выполняться на главном потоке
     */
    func addEmployee(employeeDetails: EmployeeDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод удаления сотрудника из массива
     
     - parameters:
        - id: уникальный id сотрудника, которого необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteEmployee(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод редактирования сотрудника в массиве
     
     - parameters:
        - id: уникальный id сотрудника, которого необходимо отредактировать
        - editedEmployee: отредактированные данные сотрудника
        - completion: блок, который будет выполняться на главном потоке
     */
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод получения массива сотрудников с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив сотрудников, либо ошибка
     */
    func getEmployees(_ completion: @escaping (Result<[Employee], BaseError>) -> Void)
    
    /**
     Метод добавления нового проекта в массив
     
     - parameters:
        - projectDetails: модель проекта для добавления в массив и последующего сохранения
        - completion: блок, который будет выполняться на главном потоке
     */
    func addProject(projectDetails: ProjectDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод удаления проекта из массива
     
     - parameters:
        - id: уникальный id проекта, который необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteProject(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод редактирования проекта в массиве
     
     - parameters:
        - id: уникальный id проекта, который необходимо отредактировать
        - editedProject: отредактированные данные проекта
        - completion: блок, который будет выполняться на главном потоке
     */
    func editProject(id: Int, editedProject: Project, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод получения массива проектов с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив проектов, либо ошибка
     */
    func getProjects(_ completion: @escaping (Result<[Project], BaseError>) -> Void)
    
    /**
     Метод добавления новой задачи в массив
     
     - parameters:
        - taskDetails: модель задачи для добавления в массив и последующего сохранения
        - completion: блок, который будет выполняться на главном потоке
     */
    func addTask(taskDetails: TaskDetails, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод удаления задачи из массива
     
     - parameters:
        - id: уникальный id задачи, которую необходимо удалить
        - completion: блок, который будет выполняться на главном потоке
     */
    func deleteTask(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод редактирования задачи в массиве
     
     - parameters:
        - id: уникальный id задачи, которую необходимо отредактировать
        - editedTask: отредактированные данные задачи
        - completion: блок, который будет выполняться на главном потоке
     */
    func editTask(id: Int, editedTask: Task, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    
    /**
     Метод получения массива задач с сервера
     
     - parameters:
        - completion: блок, в котором в зависимости от результата будет передаваться либо массив задач, либо ошибка
     */
    func getTasks(_ completion: @escaping (Result<[Task], BaseError>) -> Void)
    
    /**
     Метод получения массива задач для определенного проекта с сервера
     
     - parameters:
        - project: проект, для которого необходимо получить задачи
        - completion: блок, в котором происходит обработка запроса,
    в случае успеха передается массив задач, в случае неудачи обработка ошибки
     */
    func getTasksFor(project: Project, _ completion: @escaping (Result<[Task], BaseError>) -> Void)
}
