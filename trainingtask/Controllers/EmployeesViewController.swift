//
//  EmployeesViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 20.09.22.
//

import UIKit

class EmployeesViewController: UIViewController {
    
    //MARK: - Private property
    
    private enum EmployeeMenu: String, CaseIterable {
        case Фамилия, Имя, Отчество, Должность
    }
    
    private var tableView = UITableView()
    private var addNewEmployeeButton = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private static let newCellIdentifier = "NewCell"
    private var employeeArray: [Employee] = []
    
    //MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.title = "Сотрудники"
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    //MARK: - Setup function
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EmployeesCustomCell.self, forCellReuseIdentifier: EmployeesViewController.newCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        addNewEmployeeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEmployee(_:)))
        navigationItem.rightBarButtonItem = addNewEmployeeButton
    }
    
    //MARK: - Targets
    
    @objc func addNewEmployee(_ sender: UIBarButtonItem) {
        // transition to new VC
    }
}

//MARK: - Extension TableView

extension EmployeesViewController: UITableViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension EmployeesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesViewController.newCellIdentifier, for: indexPath) as? EmployeesCustomCell else { return UITableViewCell() }
        cell.surnameText = employeeArray[indexPath.row].surname
        cell.nameText = employeeArray[indexPath.row].name
        cell.patronymicText = employeeArray[indexPath.row].patronymic
        cell.positionText = employeeArray[indexPath.row].position
        
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
}
