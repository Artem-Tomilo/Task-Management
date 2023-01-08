import Foundation

/*
 Протокол ProjectEditViewControllerDelegate - интерфейс для взаимодействия с экраном Список проектов
 */

protocol ProjectEditViewControllerDelegate: AnyObject {
    func addProjectDidCancel(_ controller: ProjectEditViewController)
    func addNewProject(_ controller: ProjectEditViewController, newProject: Project)
    func editProject(_ controller: ProjectEditViewController, editedProject: Project)
}
