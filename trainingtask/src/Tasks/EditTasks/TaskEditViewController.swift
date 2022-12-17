//
//  TaskEditViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskEditViewController: UIViewController, TaskEditViewDelegate {
    
    private let taskEditView = TaskEditView()
    private var projects: [Project] = []
    private var employees: [Employee] = []
    private var status = TaskStatus.allCases
    private var data = [String]()
    var possibleTaskToEdit: Task?
    
    weak var delegate: TaskEditViewControllerDelegate?
    private let serverDelegate: Server
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
        taskEditView.delegate = self
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(taskEditView)
        
        NSLayoutConstraint.activate([
            taskEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            taskEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            taskEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let taskToEdit = possibleTaskToEdit {
            title = "Редактирование задачи"
            taskEditView.bind(task: taskToEdit)
        } else {
            let numbersOfDays = getNumberOfDaysBetweenDates()
            taskEditView.bindEndDateTextField(days: numbersOfDays)
            title = "Добавление задачи"
        }
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
        
        getProjects()
        getEmployees()
    }
    
    private func getProjects() {
        serverDelegate.getProjects({ [weak self] projects in
            guard let self = self else { return }
            self.projects = projects
        })
    }
    
    private func getEmployees() {
        serverDelegate.getEmployees({ [weak self] employees in
            guard let self = self else { return }
            self.employees = employees
        })
    }
    
    private func setDataFromProjects() {
        data.removeAll()
        for i in projects {
            data.append(i.name)
        }
    }
    
    private func setDataFromEmployees() {
        data.removeAll()
        for i in employees {
            data.append(i.surname + " " + i.name + " " + i.patronymic)
        }
    }
    
    private func setDataFromStatus() {
        data.removeAll()
        for i in TaskStatus.allCases {
            data.append(i.title)
        }
    }
    
    private func getNumberOfDaysBetweenDates() -> Int {
        guard let count = try? settingsManager.getSettings().maxDays else { return 0 }
        return count
    }
    
    private func createNewTask() {
        
    }

    private func editingTask(editedTask: Task) {
        
    }
    
    private func saveTask() {
        if let editedTask = possibleTaskToEdit {
            editingTask(editedTask: editedTask)
        } else {
            createNewTask()
        }
    }
    
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        saveTask()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
    
    func bindData() -> [String] {
        if taskEditView.isProjectTextField {
            setDataFromProjects()
        }

        if taskEditView.isEmployeeTextField {
            setDataFromEmployees()
        }

        if taskEditView.isStatusTextField {
            setDataFromStatus()
        }
        return data
    }
}
