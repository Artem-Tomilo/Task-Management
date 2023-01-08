import Foundation

/*
 Протокол TaskEditViewControllerDelegate - интерфейс для взаимодействия с экраном Список задач
 */

protocol TaskEditViewControllerDelegate: AnyObject {
    func addTaskDidCancel(_ controller: TaskEditViewController)
    func addNewTask(_ controller: TaskEditViewController, newTask: Task)
    func editTask(_ controller: TaskEditViewController, editedTask: Task)
}
