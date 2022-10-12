import UIKit

/*
 EmployeesListController - экран Список сотрудников, отображает tableView со всеми сотрудниками, хранящимися на сервере
 */
class EmployeesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    
    var employeeArray: [Employee]?
    
    private static let newCellIdentifier = "NewCell"
    
    var idCounter = 0 // счетчик, присваивающий уникальный id создаваемому сотруднику
    var serverDelegate: Server! // делегат, вызывающий методы обработки сотрудников на сервере
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData {
            self.tableView.reloadData()
        }
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        self.title = "Сотрудники"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeesListController.newCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        addNewEmployeeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEmployee(_:)))
        navigationItem.rightBarButtonItem = addNewEmployeeButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     parameters:
     cell - ячейка, в которой отображается сотрудник
     employee - сотрудник, хранящийся в этой ячейке, данными которого она будет заполняться
     */
    func settingCellText(for cell: UITableViewCell, with employee: Employee) {
        if let cell = cell as? EmployeeCell {
            cell.bindText(surnameText: employee.surname, nameText: employee.name, patronymicText: employee.patronymic, positionText: employee.position)
        }
    }
    
    /*
     getMaxRecordsCount - получение значения максимального количетсва записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        let settingsManager = SettingsManager()
        var count = 0
        let settings = settingsManager.getSettings()
        count = Int(settings.maxRecords) ?? 0
        return count
    }
    
    /*
     Функция загрузки данных - происходит сравнение кол-ва объектов в массиве с сервера с максимальным кол-вом записей из настроек, по результату сравнения массив employeeArray заполняется нужным кол-вом элементов
     блок completion вызывается после передачи данных с сервера и как правило обновляет таблицу
     */
    func loadData(_ completion: @escaping () -> Void) {
        let array = serverDelegate.getEmployees()
        if getMaxRecordsCountFromSettings() != 0 && getMaxRecordsCountFromSettings() <= array.count {
            employeeArray = Array(array[0..<getMaxRecordsCountFromSettings()])
        } else {
            employeeArray = serverDelegate.getEmployees()
        }
        completion()
    }
    
    func showSpinner() {
        spinnerView = SpinnerView(frame: self.view.bounds)
        view.addSubview(spinnerView)
        navigationController?.navigationBar.alpha = 0.3
    }
    
    func removeSpinner() {
        spinnerView.removeFromSuperview()
        navigationController?.navigationBar.alpha = 1.0
    }
    
    /*
     Метод удаления ячейки из tableView с последующим обновлением
     */
    func reloadTableView(tableView: UITableView, indexPath: IndexPath) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } completion: { _ in
            self.loadData() {
                tableView.reloadData()
            }
        }
    }
    
    /*
     вызов метода добавления нового сотрудника на сервере, путем обращения к делегату, с последующим обновлением tableView, а также обработкой спиннера
     
     parameters:
     employee - добавляемый сотрудник
     */
    private func callServerDelegateAddNewEmployeeFunction(employee: Employee) throws {
        self.showSpinner()
        idCounter += 1
        try serverDelegate.addEmployee(employee: employee) {
            self.loadData {
                self.tableView.reloadData()
            }
            self.removeSpinner()
        }
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = serverDelegate.getEmployees()
        if employeeArray?.count ?? 0 < array.count {
            return employeeArray?.count ?? 0
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListController.newCellIdentifier, for: indexPath) as? EmployeeCell else { return UITableViewCell() }
        if let employee = employeeArray?[indexPath.row] {
            settingCellText(for: cell, with: employee)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EmployeeCell()
        cell.bindText(surnameText: EmployeeMenu.Surname.title, nameText: EmployeeMenu.Name.title, patronymicText: EmployeeMenu.Patronymic.title, positionText: EmployeeMenu.Position.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        35
    }
    
    /*
     Удаление и редактирование сотрудника происходит после свайпа влево
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let helper = DeleteEmployeeHelper(vc: self)
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { _, _, close in
            let alert = UIAlertController(title: "Хотите удалить этого сотрудника?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                helper.deleteEmployee(tableView: tableView, indexPath: indexPath)
            }
            let secondAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            alert.addAction(secondAction)
            self.present(alert, animated: true)
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [self] _, _, close in
            let alert = UIAlertController(title: "Хотите изменить этого сотрудника?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Изменить", style: .default) { _ in
                let vc = EmployeeEditViewController()
                vc.delegate = self
                vc.possibleEmployeeToEdit = self.employeeArray?[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let secondAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            alert.addAction(secondAction)
            self.present(alert, animated: true)
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    /*
     addNewEmployee - target на кнопку добавления нового сотрудника:
     переходит на экран Редактирование сотрудника
     */
    @objc func addNewEmployee(_ sender: UIBarButtonItem) {
        let vc = EmployeeEditViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     refresh - таргет на обновление таблицы через UIRefreshControl
     */
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData {
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    /*
     addEmployeeDidCancel - метод протокола EmployeeEditViewControllerDelegate, который возвращает на экран Список сотрудников после нажатия кнопки Cancel
     
     Параметр controller - ViewController, на котором вызывается данный метод
     */
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     addNewEmployee - метод протокола EmployeeEditViewControllerDelegate, который добавляет нового сотрудника в массив на сервере, останавливает спиннер и возвращает на экран Список сотрудников
     
     Параметр newEmployee - новый сотрудник для добавления
     Параметр controller - ViewController, на котором вызывается данный метод
     */
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee) {
        do {
            self.navigationController?.popViewController(animated: true)
            try callServerDelegateAddNewEmployeeFunction(employee: newEmployee)
        } catch {
            // асинхронная обработка ошибки
        }
    }
    
    /*
     editEmployee - метод протокола EmployeeEditViewControllerDelegate, который изменяет данные сотрудника:
     сначала происходит проверка нахождения сотрудника в массиве на сервере, потом происходит изменение его данных, остановка спиннера и возврат на экран Список сотрудников
     
     parameters:
     newData - данные сотрудника, после изменения
     previousData - данные сотрудника до изменения
     controller - ViewController, на котором вызывается данный метод
     */
    func editEmployee(_ controller: EmployeeEditViewController, newData: Employee, previousData: Employee) {
        let editHelper = EditEmployeeHelper(vc: self)
        guard editHelper.checkEmployeeInArray(employee: previousData, employeeArray: employeeArray ?? []) == true,
              let index = employeeArray?.firstIndex(of: previousData) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeCell else { return }
        
        do {
            self.navigationController?.popViewController(animated: true)
            try editHelper.callServerDelegateEditFunction(newData: newData, previousData: previousData, cell: cell, tableView: tableView)
        } catch {
            // асинхронная обработка ошибки
        }
    }
}
