import UIKit

/**
 Перечисления параметров сотрудника
 */
enum EmployeeMenu: String, CaseIterable {
    
    /**
     Фамилия
     */
    case surname
    
    /**
     Имя
     */
    case name
    
    /**
     Отчество
     */
    case patronymic
    
    /**
     Должность
     */
    case position
}
