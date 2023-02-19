import Foundation

/**
 Модель, содержащая необходимые данные для заполнения TaskEditView
 */
struct TaskBindModel {
    
    /**
     Возможная задача, записывается если пришла задача для редактирования
     */
    var task: Task?
    
    /**
     Возможный проект, с которого был осуществлен переход на экран задач,
     если значение присутствует, то поле ввода проекта будет закрыто для редактирования
     */
    var project: Project?
    
    /**
     Количество дней между датой начала и окончания задачи, записывается из настроек приложения
     */
    var daysBetweenDates: Int?
    
    /**
     Список проектов, полученный с сервера
     */
    var listProjects: [Project]?
    
    /**
     Список сотрудников, полученный с сервера
     */
    var listEmployees: [Employee]?
}