import UIKit

/*
 DeleteEmployeeHelper - класс, содержащие вспомогательные методы для удаления сотрудника
 */
class DeleteEmployeeHelper {
    
    weak var vc: EmployeesListController?
    
    init(vc: EmployeesListController) {
        self.vc = vc
    }
    
    /*
     Сравнение двух массивов на количество элементов для определения нужного метода удаления
     
     parameters:
     firstArray - текущий массив из vc
     secondArray - массив сотрудников, хранящийся на сервере
     Возвращаемое значение типа Bool, если secondArray больше, то возвращается true
     */
    private func compareArraysByCount(firstArray: [Employee], secondArray: [Employee]) -> Bool {
        if firstArray.count <= secondArray.count {
            return true
        }
        return false
    }
    
    /*
     метод удаления сотрудника из частичного массива всех сотрудников, также удаляет сотрудника на сервере, путем обращения к делегату, с последующим обновлением tableView, а также обработкой спиннера
     
     parameters:
     employee - удаляемый сотрудник
     tableView - текущее tableView, которое будет обновлено после удаления
     indexPath - indexPath, нужный для обновления tableView
     */
    private func removeEmployeeFromPartlyArray(employee: Employee, tableView: UITableView, indexPath: IndexPath) throws {
        vc?.showSpinner()
        try vc?.serverDelegate.deleteEmployee(with: employee.id) {
            self.vc?.employeeArray?.removeAll(where: { $0.id == employee.id })
            self.vc?.reloadTableView(tableView: tableView, indexPath: indexPath)
            self.vc?.removeSpinner()
        }
    }
    
    /*
     вызов метода удаления сотрудника на сервере, путем обращения к делегату, с последующим обновлением tableView, а также обработкой спиннера
     
     parameters:
     employee - удаляемый сотрудник
     tableView - текущее tableView, которое будет обновлено после удаления
     indexPath - indexPath, нужный для обновления tableView
     */
    private func removeEmployeeFromFullArray(employee: Employee, tableView: UITableView, indexPath: IndexPath) throws {
        vc?.showSpinner()
        try vc?.serverDelegate.deleteEmployee(with: employee.id) {
            self.vc?.employeeArray = self.vc?.serverDelegate.getEmployees()
            self.vc?.reloadTableView(tableView: tableView, indexPath: indexPath)
            self.vc?.removeSpinner()
        }
    }
    
    /*
     полный метод удаления сотрудника - содержит сборку всех методов, нужных для удаления
     
     parameters:
     tableView - таблица, в которой будет находится ячейка с сотрудником
     indexPath - IndexPath данной ячейки
     */
    func deleteEmployee(tableView: UITableView, indexPath: IndexPath) {
        guard let employee = vc?.employeeArray?[indexPath.row],
              let temporaryArray = vc?.serverDelegate.getEmployees() else { return }
        do {
            if compareArraysByCount(firstArray: vc?.employeeArray ?? [], secondArray: temporaryArray) {
                try removeEmployeeFromPartlyArray(employee: employee, tableView: tableView, indexPath: indexPath)
            } else {
                try removeEmployeeFromFullArray(employee: employee, tableView: tableView, indexPath: indexPath)
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
}
