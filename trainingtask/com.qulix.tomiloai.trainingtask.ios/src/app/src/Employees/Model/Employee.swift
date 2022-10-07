import UIKit

/*
 Структура сотрудника, содержащая поля для заполнения:
    Фамилия, имя, отчество, должность
 */

struct Employee: Codable, Equatable {
    var surname: String
    var name: String
    var patronymic: String
    var position: String
}
