//
//  EmployeesListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 20.09.22.
//

import UIKit

class EmployeesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeEditViewControllerDelegate {
    
    //MARK: - Private property
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private static let newCellIdentifier = "NewCell"
    private var employeeArray: [Employee] = []
    private var viewForIndicator = SpinnerView()
    
    var presenter: EmployeePresenterInputs!
    
    //MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showSpinner()
        loadData {
            self.tableView.reloadData()
            self.removeSpinner()
        }
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
        
        navigationController?.isNavigationBarHidden = false
        self.title = "Сотрудники"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        addNewEmployeeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEmployee(_:)))
        navigationItem.rightBarButtonItem = addNewEmployeeButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    //MARK: - Load data
    
    private func loadData(_ completion: @escaping () -> Void) {
        self.employeeArray = self.presenter?.loadEmployees() ?? []
        completion()
    }
    
    func showSpinner() {
        viewForIndicator = SpinnerView(frame: self.view.bounds)
        view.addSubview(viewForIndicator)
        navigationController?.navigationBar.alpha = 0.3
    }
    
    func removeSpinner() {
        viewForIndicator.removeFromSuperview()
        navigationController?.navigationBar.alpha = 1.0
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
    
    //MARK: - TableView
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
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
    
    //MARK: - Delete employee
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { _, _, close in
            let alert = UIAlertController(title: "Хотите удалить этого строку?", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.employeeArray.remove(at: indexPath.row)
                tableView.performBatchUpdates {
                    self.showSpinner()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } completion: { _ in
                    self.presenter?.saveEmployee(to: self.employeeArray)
                    self.tableView.reloadData()
                    self.removeSpinner()
                }
            }
            let secondAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            alert.addAction(secondAction)
            self.present(alert, animated: true)
        })
        
        //MARK: - Edit employee
        
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
            deleteCell,
            editCell
        ])
    }
    
    //MARK: - Targets
    
    @objc func addNewEmployee(_ sender: UIBarButtonItem) {
        let vc = EmployeeEditViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData {
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    //MARK: - EmployeeEditViewControllerDelegate functions
    
    func addEmployeeDidCancel(_ controller: EmployeeEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addNewEmployee(_ controller: EmployeeEditViewController, newEmployee: Employee) {
        employeeArray.append(newEmployee)
        presenter?.saveEmployee(to: employeeArray)
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
        presenter?.saveEmployee(to: employeeArray)
    }
}
