import UIKit

/*
 EmployeesListController - экран Список сотрудников, отображает tableView со всеми сотрудниками, хранящимися на сервере
 */
class EmployeesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    
    private var employeeArray: [Employee]?
    private lazy var partialEmployeeArray: [Employee] = []
    
    private static let newCellIdentifier = "NewCell"
    
    var idCounter = 0 // счетчик, присваивающий уникальный id создаваемому сотруднику
    var serverDelegate: Server! // делегат, вызывающий методы обработки сотрудников на сервере
    private var employeeController = EmployeeController()
    
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
     employee - сотрудник, хранящийся в этой ячейку, данными которого она и будет заполняться
     */
    private func settingCellText(for cell: UITableViewCell, with employee: Employee) {
        if let cell = cell as? EmployeeCell {
            cell.surnameText = employee.surname
            cell.nameText = employee.name
            cell.patronymicText = employee.patronymic
            cell.positionText = employee.position
        }
    }
    
    /*
     Функция обновления данных, блок completion вызывается после передачи данных с сервера и как правило обновляет таблицу
     */
    func loadData(_ completion: @escaping () -> Void) {
        employeeArray = serverDelegate.getEmployees()
        partialEmployeeArray = employeeController.checkArrayToDisplay(employeeArray: employeeArray ?? [])
        completion()
    }
    
    private func showSpinner() {
        spinnerView = SpinnerView(frame: self.view.bounds)
        view.addSubview(spinnerView)
        navigationController?.navigationBar.alpha = 0.3
    }
    
    func removeSpinner() {
        spinnerView.removeFromSuperview()
        navigationController?.navigationBar.alpha = 1.0
    }
    
    /*
     Метод удаления сотрудника:
     
     parameters:
     tableView - таблица, в которой будет находится ячейка с сотрудников
     indexPath - IndexPath данной ячейки
     */
    private func deleteEmployee(tableView: UITableView, indexPath: IndexPath) {
        guard let employee = employeeArray?[indexPath.row] else { return }
        if partialEmployeeArray.isEmpty {
            do {
                try serverDelegate.deleteEmployee(with: employee.id) {
                    self.employeeArray = self.serverDelegate.getEmployees()
                    self.employeeController.reloadTableView(tableView: tableView, indexPath: indexPath, vc: self)
                }
            } catch {
                DispatchQueue.global().async {
                    print(error.localizedDescription)
                }
            }
        } else {
            do {
                try serverDelegate.deleteEmployee(with: employee.id) {
                    self.employeeArray = self.serverDelegate.getEmployees()
                    self.partialEmployeeArray.removeAll(where: { $0.id == employee.id })
                    self.employeeController.reloadTableView(tableView: tableView, indexPath: indexPath, vc: self)
                }
            } catch {
                DispatchQueue.global().async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !partialEmployeeArray.isEmpty {
            return partialEmployeeArray.count
        } else {
            return employeeArray?.count ?? 0
        }
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
        cell.surnameText = EmployeeMenu.Surname.title
        cell.nameText = EmployeeMenu.Name.title
        cell.patronymicText = EmployeeMenu.Patronymic.title
        cell.positionText = EmployeeMenu.Position.title
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
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { _, _, close in
            let alert = UIAlertController(title: "Хотите удалить этого сотрудника?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.showSpinner()
                self.deleteEmployee(tableView: tableView, indexPath: indexPath)
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
            self.showSpinner()
            idCounter += 1
            try serverDelegate.addEmployee(employee: newEmployee) {
                self.loadData {
                    self.tableView.reloadData()
                }
                self.removeSpinner()
            }
        } catch {
            DispatchQueue.global().async {
                print(error.localizedDescription)
            }
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
        if employeeController.checkEmployeeInArray(employee: previousData, employeeArray: employeeArray ?? []) {
            guard let index = employeeArray?.firstIndex(of: previousData) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeCell else { return }
            do {
                self.navigationController?.popViewController(animated: true)
                self.showSpinner()
                try serverDelegate.editEmployee(with: previousData.id, newData: newData) {
                    self.employeeArray = self.serverDelegate.getEmployees()
                    self.settingCellText(for: cell, with: newData)
                    self.tableView.reloadData()
                    self.removeSpinner()
                }
            } catch {
                DispatchQueue.global().async {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
