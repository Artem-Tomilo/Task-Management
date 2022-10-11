import UIKit

/*
 EmployeeController - вспомогательный класс, хранящий методы для обработки сотрудника, его проверки, обновления
 */
class EmployeeController {
    
    /*
     checkEmployeeInArray - метод проверки сотрудника в массиве, пришедший с сервера
     
     параметр employee - проверяемый сотрудник
     параметр employeeArray - массив, в котором происходит проверка
     */
    func checkEmployeeInArray(employee: Employee, employeeArray: [Employee]) -> Bool {
        for employeeInArray in employeeArray {
            if employeeInArray == employee {
                return true
            }
        }
        return false
    }
    
    /*
     reloadTableView - метод для обновления tableView после удаления сотрудника
     
     параметр tableView - обновляемая таблица
     параметр vc - ViewController, в котором происходит обновление
     */
    func reloadTableView(tableView: UITableView, indexPath: IndexPath, vc: EmployeesListController) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } completion: { _ in
            vc.loadData {
                tableView.reloadData()
                vc.removeSpinner()
            }
        }
    }
    
    /*
     getMaxRecordsCount - получение значения максимального количетсва записей из настроек приложения
     */
    private func getMaxRecordsCount() -> Int {
//        if let settings = UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) {
//            for (key, value) in settings {
//                switch key {
//                case "Records":
//                    let value = value as? String ?? "0"
//                    count = Int(value) ?? 0
//                    return count
//                default:
//                    break
//                }
//            }
//        }
        let settingsManager = SettingsManager()
        var count = 0
        if let settings = settingsManager.getSettings() {
            count = Int(settings.maxRecords) ?? 0
            return count
        }
        return 0
    }
    
    /*
     checkArrayToDisplay - сравнение количества сотрудников в массиве со значением максимального количества записей
     
     Параметр employeeArray - проверяемый массив
     Возвращаемое значение [Employee] - новый массив, который будет отображаться, если количество записей меньше либо равно количеству сотрудников в массиве
     */
    func checkArrayToDisplay(employeeArray: [Employee]) -> [Employee] {
        if getMaxRecordsCount() != 0 && getMaxRecordsCount() <= employeeArray.count {
            var partialEmployeeArray: [Employee] = []
            partialEmployeeArray = Array(employeeArray[0..<getMaxRecordsCount()])
            return partialEmployeeArray
        }
        return []
    }
}
