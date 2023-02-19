import Foundation

/**
 Редактируемая модель сотрудника для передачи данных на сервер
 */
struct EmployeeDetails {
    
    /**
     Фамилия
     */
    let surname: String
    
    /**
     Имя
     */
    let name: String
    
    /**
     Отчество
     */
    let patronymic: String
    
    /**
     Должность
     */
    let position: String
}
