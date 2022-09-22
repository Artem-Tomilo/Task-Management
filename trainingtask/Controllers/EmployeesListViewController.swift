//
//  EmployeesListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 20.09.22.
//

import UIKit

class EmployeesListViewController: UIViewController {
    
    //MARK: - Private property
    
    private enum EmployeeMenu: String, CaseIterable {
        case Фамилия, Имя, Отчество, Должность
    }
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private static let newCellIdentifier = "NewCell"
    private var repository = EmployeeRepository()
    private var employeeArray: [Employee] = []
    
    //MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.title = "Сотрудники"
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        
        employeeArray = repository.getEmployee()
    }
    
    //MARK: - Setup function
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EmployeesCustomCell.self, forCellReuseIdentifier: EmployeesListViewController.newCellIdentifier)
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
    }
    
    //MARK: - ConfigureText
    
    func configureText(for cell: UITableViewCell, with employee: Employee) {
        if let cell = cell as? EmployeesCustomCell {
            cell.surnameText = employee.surname
            cell.nameText = employee.name
            cell.patronymicText = employee.patronymic
            cell.positionText = employee.position
        }
    }
    
    //MARK: - Targets
    
    @objc func addNewEmployee(_ sender: UIBarButtonItem) {
        let vc = EmployeeEditViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
    }
}

//MARK: - Extension TableView

extension EmployeesListViewController: UITableViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension EmployeesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListViewController.newCellIdentifier, for: indexPath) as? EmployeesCustomCell else { return UITableViewCell() }
        let employee = employeeArray[indexPath.row]
        configureText(for: cell, with: employee)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EmployeesCustomCell()
        cell.surnameText = EmployeeMenu.Фамилия.rawValue
        cell.nameText = EmployeeMenu.Имя.rawValue
        cell.patronymicText = EmployeeMenu.Отчество.rawValue
        cell.positionText = EmployeeMenu.Должность.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        35
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [self] _, _, close in
            let alert = UIAlertController(title: "Хотите изменить строку?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Изменить", style: .default) { _ in
                let vc = EmployeeEditViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                vc.delegate = self
                vc.employeeToEdit = self.employeeArray[indexPath.row]
            }
            let secondAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            alert.addAction(secondAction)
            self.present(alert, animated: true)
        })
        return UISwipeActionsConfiguration(actions: [
            editCell
        ])
    }
}

//MARK: - EmployeeDataViewControllerDelegate

extension EmployeesListViewController: EmployeeEditViewControllerDelegate {
    
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee) {
        employeeArray.append(newEmployee)
        repository.saveEmployee(array: self.employeeArray)
        navigationController?.popViewController(animated: true)
    }
    
    func editEmployee(_ controller: EmployeeEditViewController, newData: Employee, previousData: Employee) {
        if let index = employeeArray.firstIndex(of: previousData) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? EmployeesCustomCell {
                employeeArray.remove(at: index)
                employeeArray.insert(newData, at: index)
                configureText(for: cell, with: newData)
            }
        }
        navigationController?.popViewController(animated: true)
        repository.saveEmployee(array: self.employeeArray)
    }
}
