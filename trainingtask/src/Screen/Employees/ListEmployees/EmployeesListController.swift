import UIKit

/*
 EmployeesListController - экран Список сотрудников, отображает tableView со всеми сотрудниками, хранящимися на сервере
 */
class EmployeesListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let spinnerView = SpinnerView()
    private static let newCellIdentifier = "NewCell"
    private var employeeArray: [Employee] = []
    
    private let server: Server
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager, server: Server) {
        self.settingsManager = settingsManager
        self.server = server
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func configureUI() {
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
        
        let addNewEmployeeButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                   target: self,
                                                   action: #selector(moveToEditEmployeeViewController(_:)))
        navigationItem.rightBarButtonItem = addNewEmployeeButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     Метод получения значения максимального количества записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        return settingsManager.getSettings().maxRecords
    }
    
    /*
     Метод загрузки данных - происходит запуск спиннера и вызов метода сервера:
     в completion блоке вызывается метод привязки данных согласно количеству записей из настроек и скрытие спиннера,
     в случае ошибки происходит ее обработка
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        server.getEmployees { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let employees):
                if self.getMaxRecordsCountFromSettings() != 0 {
                    self.bind(Array(employees.prefix(self.getMaxRecordsCountFromSettings())))
                } else {
                    self.bind(employees)
                }
                self.spinnerView.hideSpinner()
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
            }
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
    
    /*
     Метод получения параметров сотрудника в строковом варианте
     
     parameters:
     menu - список параметров
     Возвращаемое значение - строковый вариант параметра
     */
    private func getEmployeeMenuTitleFrom(_ menu: EmployeeMenu) -> String {
        switch menu {
        case .surname:
            return "Фамилия"
        case .name:
            return "Имя"
        case .patronymic:
            return "Отчество"
        case .position:
            return "Должность"
        }
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListController.newCellIdentifier,
                                                       for: indexPath) as? EmployeeCell else { return UITableViewCell() }
        let employee = employeeArray[indexPath.row]
        cell.bind(employee)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EmployeeCell()
        let employee = Employee(surname: getEmployeeMenuTitleFrom(EmployeeMenu.surname),
                                name: getEmployeeMenuTitleFrom(EmployeeMenu.name),
                                patronymic: getEmployeeMenuTitleFrom(EmployeeMenu.patronymic),
                                position: getEmployeeMenuTitleFrom(EmployeeMenu.position))
        cell.bind(employee)
        return cell
    }
    
    /*
     Удаление и редактирование сотрудника происходит после свайпа влево, в случае ошибки происходит ее обработка
     */
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
     Метод получения текущего сотрудника, в случае ошибки происходит ее обработка
     
     parameters:
     indexPath сотрудника
     Возвращаемое значение - сотрудник
     */
    private func getEmployee(_ indexPath: IndexPath) throws -> Employee {
        if employeeArray.count > indexPath.row {
            return employeeArray[indexPath.row]
        }
        else {
            throw BaseError(message: "Не удалось получить сотрудника")
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let employeeError = error as! BaseError
        ErrorAlert.showAlertController(message: employeeError.message, viewController: self)
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
            self.deleteEmployee(employee)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод перехода на экран Редактирование сотрудника
     
     parameters:
     employee - передаваемый сотрудник для редактирования, если значение = nil, то будет создание нового сотрудника
     */
    private func showEditEmployeeViewController(_ employee: Employee?) {
        if let employee {
            let viewController = EmployeeEditViewController(server: server, possibleEmployeeToEdit: employee)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = EmployeeEditViewController(server: server, possibleEmployeeToEdit: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    /*
     Метод удаления сотрудника - вызывает метод делагата для удаления сотрудника с сервера,
     после обновляет данные на главном потоке, в случае ошибки происходит ее обработка
     
     parameters:
     employee - сотрудник для удаления
     */
    private func deleteEmployee(_ employee: Employee) {
        server.deleteEmployee(id: employee.id) { result in
            switch result {
            case .success():
                self.loadData()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    /*
     Target на кнопку добавления нового сотрудника:
     переходит на экран Редактирование сотрудника
     */
    @objc func moveToEditEmployeeViewController(_ sender: UIBarButtonItem) {
        showEditEmployeeViewController(nil)
    }
    
    /*
     Target на обновление таблицы через UIRefreshControl
     */
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
}
