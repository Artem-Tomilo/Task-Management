//
//  MainMenuViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 19.09.22.
//

import UIKit

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Private property
    
    private var tableView = UITableView()
    private static let cellIdentifier = "Cell"
    
    //MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        tableView.backgroundColor = .systemRed
    }
    
    //MARK: - Setup function
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCustomCell.self, forCellReuseIdentifier: MainMenuViewController.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainMenuList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMenuViewController.cellIdentifier, for: indexPath) as? MenuCustomCell else { return UITableViewCell() }
        cell.text = MainMenuList.allCases[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let builder = ModelBuilder()
        switch indexPath.row {
        case 2:
            let newVC = builder.createModule()
            navigationController?.pushViewController(newVC, animated: true)
        case 3:
            let settings = builder.createSettings()
            navigationController?.pushViewController(settings, animated: true)
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / CGFloat(MainMenuList.allCases.count)
    }
}