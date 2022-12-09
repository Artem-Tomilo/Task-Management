//
//  ProjectsListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class ProjectsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let settingsManager: SettingsManager
    private var tableView = UITableView()
    private static let projectCellIdentifier = "NewCell"
    private var projectsArray: [Project] = []
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let p = Project(name: "Project", description: "Description")
        projectsArray.append(p)
        tableView.reloadData()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        self.title = "Проекты"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProjectCell.self, forCellReuseIdentifier: ProjectsListViewController.projectCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let addNewProjectButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToEditProjectViewController(_:)))
        navigationItem.rightBarButtonItem = addNewProjectButton
    }
    
    @objc func moveToEditProjectViewController(_ sender: UIBarButtonItem) {
        showEditProjectViewController(nil)
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsListViewController.projectCellIdentifier, for: indexPath) as? ProjectCell else { return UITableViewCell() }
        let project = projectsArray[indexPath.row]
        cell.bindText(nameText: project.name, descriptionText: project.description)
//        settingCellText(for: cell, with: project)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            self.showDeleteEmployeeAlert(self.projectsArray[indexPath.row])
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            self.showEditEmployeeAlert(self.projectsArray[indexPath.row])
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    private func showEditEmployeeAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите изменить этот проект?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            self?.showEditProjectViewController(project)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func showDeleteEmployeeAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите удалить этот проект?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func showEditProjectViewController(_ project: Project?) {
        let viewController = EditProjectViewController()
        viewController.possibleProjectToEdit = project
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
