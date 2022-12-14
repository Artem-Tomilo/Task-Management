//
//  TaskEditViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskEditViewController: UIViewController {
    
    private let taskEditView = TaskEditView()
    var possibleTaskToEdit: Task?
    weak var delegate: TaskEditViewControllerDelegate?
//    weak var serverDelegate: Server?
//    private let picker = TaskPickerView()
//
//    private var projects: [Project] = []
//    private var employees: [Employee] = []
//    private var status = TaskStatus.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
//    func bindData() {
//        if taskEditView.project {
//            serverDelegate?.getProjects({ projects in
//                self.projects = projects
//            })
//        }
//    }
    
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
            title = "Добавление задачи"
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func createNewTask() {
        
    }
    
    private func saveTask() {
        if let editedTask = possibleTaskToEdit {
            editingTask(editedTask: editedTask)
        } else {
            createNewTask()
        }
    }

    private func editingTask(editedTask: Task) {
        
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
}
