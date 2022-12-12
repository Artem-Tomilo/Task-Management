import Foundation

/*
 Protocol Server - интерфейс взаимодействия с сервером
 */
protocol Server: AnyObject {
    func addEmployee(employee: Employee, _ completion: @escaping () -> Void) throws
    func deleteEmployee(id: Int, _ completion: @escaping () -> Void) throws
    func editEmployee(id: Int, editedEmployee: Employee, _ completion: @escaping () -> Void) throws
    func getEmployees(_ completion: @escaping ([Employee]) -> Void)
    func addProject(project: Project, _ completion: @escaping () -> Void) throws
    func deleteProject(id: Int, _ completion: @escaping () -> Void) throws
    func editProject(id: Int, editedProject: Project, _ completion: @escaping () -> Void) throws
    func getProjects(_ completion: @escaping ([Project]) -> Void)
    func deleteTask(id: Int, _ completion: @escaping () -> Void) throws
    func getTasks(_ completion: @escaping ([Task]) -> Void)
}
