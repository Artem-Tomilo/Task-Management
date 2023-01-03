import UIKit

/*
 EmployeesListController - экран Список сотрудников, отображает tableView со всеми сотрудниками, хранящимися на сервере
 */
class EmployeesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let newCellIdentifier = "NewCell"
    private var employeeArray: [Employee] = []
    private let alertController = Alert()
    
    private var serverDelegate: Server // делегат, вызывающий методы обработки сотрудников на сервере
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager, serverDelegate: Server) {
        self.settingsManager = settingsManager
        self.serverDelegate = serverDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
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
        
        addNewEmployeeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToEditEmployeeViewController(_:)))
        navigationItem.rightBarButtonItem = addNewEmployeeButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     parameters:
     cell - ячейка, в которой отображается сотрудник
     employee - сотрудник, хранящийся в этой ячейке, данными которого она будет заполняться
     */
    private func settingCellText(for cell: UITableViewCell, with employee: Employee) {
        if let cell = cell as? EmployeeCell {
            cell.bindText(surnameText: employee.surname, nameText: employee.name, patronymicText: employee.patronymic, positionText: employee.position)
        }
    }
    
    /*
     getMaxRecordsCount - получение значения максимального количетсва записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        guard let count = try? settingsManager.getSettings().maxRecords else { return 0 }
        return count
    }
    
    /*
     Метод загрузки данных - происходит запуск спиннера и вызов метода делегата: в completion блоке вызывается метод привязки данных и скрытие спиннера
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        serverDelegate.getEmployees { [weak self] employees in
            guard let self else { return }
            if self.getMaxRecordsCountFromSettings() != 0 {
                self.bind(Array(employees.prefix(self.getMaxRecordsCountFromSettings())))
            } else {
                self.bind(employees)
            }
            self.spinnerView.hideSpinner(from: self)
        }
    }
    
    /*
     Метод привязки данных - приходящие данные с сервера сохраняются в массив и происходит обновление таблицы
     
     parameters:
     employees - приходящий массив данных с сервера
     */
    private func bind(_ employees: [Employee]) {
        employeeArray = employees
        self.tableView.reloadData()
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListController.newCellIdentifier, for: indexPath) as? EmployeeCell else { return UITableViewCell() }
        let employee = employeeArray[indexPath.row]
        settingCellText(for: cell, with: employee)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EmployeeCell()
        cell.bindText(surnameText: EmployeeMenu.surname.title, nameText: EmployeeMenu.name.title, patronymicText: EmployeeMenu.patronymic.title, positionText: EmployeeMenu.position.title)
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
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let employee = try self.getEmployee(indexPath)
                self.showDeleteEmployeeAlert(employee)
            } catch {
                self.handleError(error)
            }
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let employee = try self.getEmployee(indexPath)
                self.showEditEmployeeAlert(employee)
            } catch {
                self.handleError(error)
            }
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    /*
     Метод получения текущего сотрудника
     
     parameters: indexPath сотрудника
     Возвращаемое значение - сотрудник
     */
    private func getEmployee(_ indexPath: IndexPath) throws -> Employee {
        if employeeArray.count > indexPath.row {
            return employeeArray[indexPath.row]
        }
        else {
            throw EmployeeStubErrors.noSuchEmployee
        }
    }
    
    private func handleError(_ error: Error) {
        let employeeError = error as! EmployeeStubErrors
        alertController.showAlertController(message: employeeError.message, viewController: self)
    }
    
    /*
     Метод вызова алерта для редактирования сотрудника и перехода на экран Редактирование сотрудника
     
     parameters:
     employee - передаваемый сотрудник для редактирования
     */
    private func showEditEmployeeAlert(_ employee: Employee) {
        let alert = UIAlertController(title: "Хотите изменить этого сотрудника?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.showEditEmployeeViewController(employee)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод вызова алерта для удаления сотрудника и последующего вызова метода удаления сотрудника
     
     parameters:
     employee - передаваемый сотрудник для удаления
     */
    private func showDeleteEmployeeAlert(_ employee: Employee) {
        let alert = UIAlertController(title: "Хотите удалить этого сотрудника?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.deleteEmployee(employee: employee)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод перехода на экран Редактирование сотрудника
     */
    private func showEditEmployeeViewController(_ employee: Employee?) {
        let viewController = EmployeeEditViewController()
        viewController.delegate = self
        if employee != nil {
            viewController.possibleEmployeeToEdit = employee
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
     Метод удаления сотрудника - вызывает метод делагата для удаления сотрудника с сервера, после обновляет данные
     
     parameters:
     employee - сотрудник для удаления
     */
    private func deleteEmployee(employee: Employee) {
        do {
            try serverDelegate.deleteEmployee(id: employee.id) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
    
    /*
     addNewEmployee - target на кнопку добавления нового сотрудника:
     переходит на экран Редактирование сотрудника
     */
    @objc func moveToEditEmployeeViewController(_ sender: UIBarButtonItem) {
        showEditEmployeeViewController(nil)
    }
    
    /*
     refresh - таргет на обновление таблицы через UIRefreshControl
     */
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    /*
     addEmployeeDidCancel - метод протокола EmployeeEditViewControllerDelegate, который возвращает на экран Список сотрудников после нажатия кнопки Cancel
     
     Параметр controller - ViewController, на котором вызывается данный метод
     */
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     addNewEmployee - метод протокола EmployeeEditViewControllerDelegate, который добавляет нового сотрудника в массив на сервере и возвращает на экран Список сотрудников
     
     Параметр controller - ViewController, на котором вызывается данный метод
     Параметр newEmployee - новый сотрудник для добавления
     */
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.addEmployee(employee: newEmployee) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
    
    /*
     editEmployee - метод протокола EmployeeEditViewControllerDelegate, который изменяет данные сотрудника
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     editedEmployee - изменяемый сотрудник
     */
    func editEmployee(_ controller: EmployeeEditViewController, editedEmployee: Employee) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.editEmployee(id: editedEmployee.id, editedEmployee: editedEmployee) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
}
