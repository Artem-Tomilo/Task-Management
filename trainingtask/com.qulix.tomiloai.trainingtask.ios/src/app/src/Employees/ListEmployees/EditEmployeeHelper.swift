import UIKit

/*
 EditEmployeeHelper - класс, содержащие вспомогательные методы для редактирования сотрудника
 */
class EditEmployeeHelper {
    
    weak var vc: EmployeesListController?
    
    init(vc: EmployeesListController) {
        self.vc = vc
    }
    
    /*
     checkEmployeeInArray - метод проверки сотрудника в массиве, пришедший с сервера
     
     parameters:
     employee - проверяемый сотрудник
     employeeArray - массив, в котором происходит проверка
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
     вызов метода редактирования сотрудника на сервере, путем обращения к делегату, с последующим обновлением tableView, а также обработкой спиннера
     
     parameters:
     previousData - данные редактируемого сотрудника
     newData - отредактированные данные сотрудника
     cell - ячейка, в которой будут обновляться данные, согласно отредактированному сотруднику
     tableView - обновляемое tableView
     */
    func callServerDelegateEditFunction(newData: Employee, previousData: Employee, cell: UITableViewCell, tableView: UITableView) throws {
        vc?.showSpinner()
        try vc?.serverDelegate.editEmployee(with: previousData.id, newData: newData) {
            self.vc?.employeeArray = self.vc?.serverDelegate.getEmployees()
            self.vc?.settingCellText(for: cell, with: newData)
            tableView.reloadData()
            self.vc?.removeSpinner()
        }
    }
}
