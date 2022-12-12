//
//  TasksListViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let taskCellIdentifier = "TaskCell"
    private var tasksArray: [Task] = []
    
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
        showSpinner()
        serverDelegate.getTasks() { tasks in
            if self.getMaxRecordsCountFromSettings() != 0 {
                self.bind(Array(tasks.prefix(self.getMaxRecordsCountFromSettings())))
            } else {
                self.bind(tasks)
            }
            self.hideSpinner()
        }
    }
    
    private func bind(_ tasks: [Task]) {
        tasksArray = tasks
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
    
    @objc func moveToEditTaskViewController(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
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
}
