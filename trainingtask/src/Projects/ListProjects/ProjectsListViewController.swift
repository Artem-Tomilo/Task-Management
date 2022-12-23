//
//  ProjectsListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class ProjectsListViewController: UIViewController, ProjectEditViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let projectCellIdentifier = "NewCell"
    private var projectsArray: [Project] = []
    
    private var serverDelegate: Server
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
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    private func settingCellText(for cell: UITableViewCell, with project: Project) {
        if let cell = cell as? ProjectCell {
            cell.bindText(nameText: project.name, descriptionText: project.description)
        }
    }
    
    private func getMaxRecordsCountFromSettings() -> Int {
        guard let count = try? settingsManager.getSettings().maxRecords else { return 0 }
        return count
    }
    
    private func loadData() {
        showSpinner()
        serverDelegate.getProjects() { projects in
            if self.getMaxRecordsCountFromSettings() != 0 {
                self.bind(Array(projects.prefix(self.getMaxRecordsCountFromSettings())))
            } else {
                self.bind(projects)
            }
            self.hideSpinner()
        }
    }
    
    private func bind(_ projects: [Project]) {
        projectsArray = projects
        self.tableView.reloadData()
    }
    
    private func showSpinner() {
        spinnerView = SpinnerView(frame: self.view.bounds)
        view.addSubview(spinnerView)
        navigationController?.navigationBar.alpha = 0.3
    }
    
    private func hideSpinner() {
        spinnerView.removeFromSuperview()
        navigationController?.navigationBar.alpha = 1.0
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
        settingCellText(for: cell, with: project)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let project = try self.getProject(indexPath)
                self.showDeleteProjectAlert(project)
            } catch {
                // асинхронная обработка ошибки
            }
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let project = try self.getProject(indexPath)
                self.showEditProjectAlert(project)
            } catch {
                // асинхронная обработка ошибки
            }
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    private func getProject(_ indexPath: IndexPath) throws -> Project {
        if projectsArray.count > indexPath.row {
            return projectsArray[indexPath.row]
        }
        else {
            throw NSError(domain: "", code: 0, userInfo: [:])
        }
    }
    
    private func showEditProjectAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите изменить этот проект?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            self?.showEditProjectViewController(project)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func showDeleteProjectAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите удалить этот проект?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.deleteProject(project: project)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func deleteProject(project: Project) {
        do {
            try serverDelegate.deleteProject(id: project.id) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
    
    private func showEditProjectViewController(_ project: Project?) {
        let viewController = ProjectEditViewController()
        if project != nil {
            viewController.possibleProjectToEdit = project
        }
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func moveToEditProjectViewController(_ sender: UIBarButtonItem) {
        showEditProjectViewController(nil)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData()
        sender.endRefreshing()
    }
    
    func addProjectDidCancel(_ controller: ProjectEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addNewProject(_ controller: ProjectEditViewController, newProject: Project) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.addProject(project: newProject) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
    
    func editProject(_ controller: ProjectEditViewController, editedProject: Project) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.editProject(id: editedProject.id, editedProject: editedProject) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
}
