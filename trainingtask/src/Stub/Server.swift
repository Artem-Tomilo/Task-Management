import Foundation

/*
 Protocol Server - интерфейс взаимодействия с сервером
 */

protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func deleteEmployee(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func getEmployees(_ completion: @escaping ([Employee]) -> Void, error: @escaping (BaseError) -> Void)
    func addProject(project: Project, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func deleteProject(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func editProject(id: Int, editedProject: Project, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func getProjects(_ completion: @escaping ([Project]) -> Void, error: @escaping (BaseError) -> Void)
    func addTask(task: Task, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func deleteTask(id: Int, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func editTask(id: Int, editedTask: Task, _ completion: @escaping (Result<Void, BaseError>) -> Void)
    func getTasks(_ completion: @escaping ([Task]) -> Void, error: @escaping (BaseError) -> Void)
    func getTasksFor(project: Project, _ completion: @escaping ([Task]) -> Void, error: @escaping (BaseError) -> Void)
}
