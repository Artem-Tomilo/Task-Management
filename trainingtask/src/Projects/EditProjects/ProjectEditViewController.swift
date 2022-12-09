//
//  ProjectEditViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class ProjectEditViewController: UIViewController {
    
    private let projectEditView = ProjectEditView()
    var possibleProjectToEdit: Project?
    weak var delegate: ProjectEditViewControllerDelegate?
    
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
            projectEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            projectEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
    
    private func createNewProject() {
        let (name, description) = projectEditView.unbind()
        let newProject = Project(name: name, description: description)
        delegate?.addNewProject(self, newProjecr: newProject)
    }
    
    private func saveProject() {
        if let editedProject = possibleProjectToEdit {
            editingProject(editedProject: editedProject)
        } else {
            createNewProject()
        }
    }

    private func editingProject(editedProject: Project) {
        let (name, description) = projectEditView.unbind()
        var project = editedProject
        project.name = name
        project.description = description
        delegate?.editProject(self, editedProject: project)
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
