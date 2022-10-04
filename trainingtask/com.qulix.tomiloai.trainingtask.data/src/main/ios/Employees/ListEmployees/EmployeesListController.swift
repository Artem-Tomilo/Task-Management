//
//  EmployeesListController.swift
//  trainingtask
//
//  Created by Артем Томило on 20.09.22.
//

import UIKit

class EmployeesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private var viewForIndicator = SpinnerView()
    
    private var employeeArray: [Employee]?
    private lazy var partialEmployeeArray: [Employee] = []
    private var count = 0
    
    private static let newCellIdentifier = "NewCell"
    
    var serverDelegate: StubServerInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showSpinner()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.loadData {
                self.tableView.reloadData()
                self.removeSpinner()
            }
        }
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
        tableView.register(EmployeesCustomCell.self, forCellReuseIdentifier: EmployeesListController.newCellIdentifier)
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
    
    private func configureText(for cell: UITableViewCell, with employee: Employee) {
        if let cell = cell as? EmployeesCustomCell {
            cell.surnameText = employee.surname
            cell.nameText = employee.name
            cell.patronymicText = employee.patronymic
            cell.positionText = employee.position
        }
    }
    
    private func loadData(_ completion: @escaping () -> Void) {
        employeeArray = serverDelegate.getEmployees()
        
        if let settings = UserDefaults.standard.dictionary(forKey: SettingsViewController.settingsKey) {
            for (key, value) in settings {
                switch key {
                case "Records":
                    let value = value as? String ?? "0"
                    count = Int(value) ?? 0
                default:
                    break
                }
            }
        }
        
        if count != 0 && count <= employeeArray?.count ?? 0 {
            partialEmployeeArray = Array(employeeArray?[0..<count] ?? [] )
        }
        completion()
    }
    
    private func showSpinner() {
        viewForIndicator = SpinnerView(frame: self.view.bounds)
        view.addSubview(viewForIndicator)
        navigationController?.navigationBar.alpha = 0.3
    }
    
    private func removeSpinner() {
        viewForIndicator.removeFromSuperview()
        navigationController?.navigationBar.alpha = 1.0
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListController.newCellIdentifier, for: indexPath) as? EmployeesCustomCell else { return UITableViewCell() }
        if let employee = employeeArray?[indexPath.row] {
            configureText(for: cell, with: employee)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EmployeesCustomCell()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { _, _, close in
            let alert = UIAlertController(title: "Хотите удалить этого сотрудника?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.showSpinner()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if self.partialEmployeeArray.isEmpty {
                        self.serverDelegate.deleteEmployees(index: indexPath.row)
                        self.employeeArray = self.serverDelegate.getEmployees()
                    } else {
                        self.serverDelegate.deleteEmployees(index: indexPath.row)
                        self.employeeArray = self.serverDelegate.getEmployees()
                        self.partialEmployeeArray.remove(at: indexPath.row)
                    }
                    tableView.performBatchUpdates {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    } completion: { _ in
                        self.loadData{
                            self.tableView.reloadData()
                            self.removeSpinner()
                        }
                    }
                }
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
                vc.employeeToEdit = self.employeeArray?[indexPath.row]
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
    
    @objc func addNewEmployee(_ sender: UIBarButtonItem) {
        let vc = EmployeeEditViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData {
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee) {
        serverDelegate.addEmployees(employee: newEmployee)
        navigationController?.popViewController(animated: true)
    }
    
    func editEmployee(_ controller: EmployeeEditViewController, newData: Employee, previousData: Employee) {
        if let index = employeeArray?.firstIndex(of: previousData) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? EmployeesCustomCell {
                serverDelegate.editEmployees(index: index, newData: newData)
                employeeArray = serverDelegate.getEmployees()
                configureText(for: cell, with: newData)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
