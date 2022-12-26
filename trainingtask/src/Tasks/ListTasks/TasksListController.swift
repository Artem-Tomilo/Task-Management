//
//  TasksListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let taskCellIdentifier = "TaskCell"
    private var tasksArray: [Task] = []
    
    var project: Project?
    
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
        self.title = "Задачи"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TasksListViewController.taskCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let addNewProjectButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToEditTaskViewController(_:)))
        navigationItem.rightBarButtonItem = addNewProjectButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    private func settingCellText(for cell: UITableViewCell, with task: Task) {
        if let cell = cell as? TaskCell {
            cell.bindText(nameText: task.name, projectText: task.project.name)
        }
    }
    
    private func getMaxRecordsCountFromSettings() -> Int {
        guard let count = try? settingsManager.getSettings().maxRecords else { return 0 }
        return count
    }
    
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        if let project {
            serverDelegate.getTasksFor(project: project) { [weak self] tasks in
                guard let self else { return }
                if self.getMaxRecordsCountFromSettings() != 0 {
                    self.bind(Array(tasks.prefix(self.getMaxRecordsCountFromSettings())))
                } else {
                    self.bind(tasks)
                }
                self.spinnerView.hideSpinner(from: self)
            }
        } else {
            serverDelegate.getTasks() { [weak self] tasks in
                guard let self else { return }
                if self.getMaxRecordsCountFromSettings() != 0 {
                    self.bind(Array(tasks.prefix(self.getMaxRecordsCountFromSettings())))
                } else {
                    self.bind(tasks)
                }
                self.spinnerView.hideSpinner(from: self)
            }
        }
    }
    
    private func bind(_ tasks: [Task]) {
        tasksArray = tasks
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksListViewController.taskCellIdentifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        let task = tasksArray[indexPath.row]
        cell.bindText(nameText: task.name, projectText: task.project.name)
        cell.changeImage(status: task.status)
        settingCellText(for: cell, with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let task = try self.getTask(indexPath)
                self.showDeleteTaskAlert(task)
            } catch {
                // асинхронная обработка ошибки
            }
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let task = try self.getTask(indexPath)
                self.showEditTaskAlert(task)
            } catch {
                // асинхронная обработка ошибки
            }
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    private func getTask(_ indexPath: IndexPath) throws -> Task {
        if tasksArray.count > indexPath.row {
            return tasksArray[indexPath.row]
        }
        else {
            throw NSError(domain: "", code: 0, userInfo: [:])
        }
    }
    
    private func showEditTaskAlert(_ task: Task) {
        let alert = UIAlertController(title: "Хотите изменить эту задачу?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.showEditTaskViewController(task)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func showDeleteTaskAlert(_ task: Task) {
        let alert = UIAlertController(title: "Хотите удалить эту задачу?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.deleteTask(task: task)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func deleteTask(task: Task) {
        do {
            try serverDelegate.deleteTask(id: task.id) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
    
    private func showEditTaskViewController(_ task: Task?) {
        let viewController = TaskEditViewController(settingsManager: settingsManager, serverDelegate: serverDelegate)
        if project != nil {
            viewController.isProjectTextFieldShouldBeDisabled = true
            viewController.project = project
        }
        if task != nil {
            viewController.possibleTaskToEdit = task
        }
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func moveToEditTaskViewController(_ sender: UIBarButtonItem) {
        showEditTaskViewController(nil)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    func addTaskDidCancel(_ controller: TaskEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addNewTask(_ controller: TaskEditViewController, newTask: Task) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.addTask(task: newTask) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
    
    func editTask(_ controller: TaskEditViewController, editedTask: Task) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.editTask(id: editedTask.id, editedTask: editedTask) {
                self.loadData()
            }
        } catch {
            // асинхронная обработка ошибки
        }
    }
}
