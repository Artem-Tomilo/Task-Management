//
//  MenuViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 19.09.22.
//

import UIKit

class MenuViewController: UIViewController {
    
    //MARK: - Private property
    
    private enum MenuList: String, CaseIterable {
        case Проекты, Задачи, Сотрудники, Настройки
    }
    
    private var tableView = UITableView()
    
    private static let cellIdentifier = "Cell"
    
    //MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
    }
    
    //MARK: - Setup function
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCustomCell.self, forCellReuseIdentifier: MenuViewController.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - Extension TableView

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuList.allCases.count
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuViewController.cellIdentifier, for: indexPath) as? MenuCustomCell else { return UITableViewCell() }
        
        cell.text = MenuList.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
//        case 2:
            //transition to new VC
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
