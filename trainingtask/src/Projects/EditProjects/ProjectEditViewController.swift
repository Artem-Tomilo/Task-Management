//
//  ProjectEditViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class ProjectEditViewController: UIViewController {
    
    private let projectEditView = ProjectEditView()
    private let alertController = Alert()
    weak var delegate: ProjectEditViewControllerDelegate?
    var possibleProjectToEdit: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(projectEditView)
        
        NSLayoutConstraint.activate([
            projectEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            projectEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        if let projectToEdit = possibleProjectToEdit {
            title = "Редактирование проекта"
            projectEditView.bind(nameTextFieldText: projectToEdit.name, descriptionTextFieldText: projectToEdit.description)
        } else {
            title = "Добавление проекта"
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func bindDataFromView() -> Project {
        let name = projectEditView.unbindProjectName()
        let description = projectEditView.unbindProjectDescription()
        
        let project = Project(name: name, description: description)
        return project
    }
    
    private func editingProject(editedProject: Project) {
        let bindedProject = bindDataFromView()
        
        var project = editedProject
        project.name = bindedProject.name
        project.description = bindedProject.description
        delegate?.editProject(self, editedProject: project)
    }
    
    private func createNewProject() {
        let newProject = bindDataFromView()
        delegate?.addNewProject(self, newProject: newProject)
    }
    
    private func validationOfEnteredData() throws {
        guard projectEditView.unbindProjectName() != "" else {
            throw ProjectEditingErrors.noName
        }
        guard projectEditView.unbindProjectDescription() != "" else {
            throw ProjectEditingErrors.noDescription
        }
    }
    
    private func handleError(error: Error) {
        let projectError = error as! ProjectEditingErrors
        switch projectError {
        case .noName:
            alertController.showAlertController(message: projectError.message, viewController: self)
        case .noDescription:
            alertController.showAlertController(message: projectError.message, viewController: self)
        }
    }
    
    private func saveProject() {
        do {
            try validationOfEnteredData()
            if let editedProject = possibleProjectToEdit {
                editingProject(editedProject: editedProject)
            } else {
                createNewProject()
            }
        }
        catch {
            handleError(error: error)
        }
    }
    
    
    
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        saveProject()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.addProjectDidCancel(self)
    }
    
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
