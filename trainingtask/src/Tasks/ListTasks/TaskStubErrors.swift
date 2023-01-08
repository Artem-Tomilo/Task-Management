import Foundation

/*
 TaskStubErrors - перечисление возможных ошибок для экрана Список задач
 
 parameters:
 message - текст ошибки, показывающийся в алерте
 */

enum TaskStubErrors: Error {
    case noSuchTask, addTaskFailed, editTaskFailed, deleteTaskFailed, noTaskList
    
    var message: String {
        switch self {
        case .noSuchTask:
            return "Не удалось получить задачу"
        case .addTaskFailed:
            return "Не удалось добавить задачу"
        case .editTaskFailed:
            return "Не удалось отредактировать задачу"
        case .deleteTaskFailed:
            return "Не удалось удалить задачу"
        case .noTaskList:
            return "Не удалось получить список задач"
        }
    }
}
