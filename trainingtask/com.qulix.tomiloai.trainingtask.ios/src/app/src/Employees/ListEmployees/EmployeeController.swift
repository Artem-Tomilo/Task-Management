import UIKit

class EmployeeController {
    
    func checkEmployeeInArray(employee: Employee, employeeArray: [Employee]) -> Bool {
        for employeeInArray in employeeArray {
            if employeeInArray == employee {
                return true
            }
        }
        return false
    }
    
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
    
    private func getMaxRecordsCount() -> Int {
        var count = 0
        if let settings = UserDefaults.standard.dictionary(forKey: UserSettings.settingsKey) {
            for (key, value) in settings {
                switch key {
                case "Records":
                    let value = value as? String ?? "0"
                    count = Int(value) ?? 0
                    return count
                default:
                    break
                }
            }
        }
        return 0
    }
    
    func checkArray(employeeArray: [Employee]) -> [Employee] {
        if getMaxRecordsCount() != 0 && getMaxRecordsCount() <= employeeArray.count {
            var partialEmployeeArray: [Employee] = []
            partialEmployeeArray = Array(employeeArray[0..<getMaxRecordsCount()])
            return partialEmployeeArray
        }
        return []
    }
}
