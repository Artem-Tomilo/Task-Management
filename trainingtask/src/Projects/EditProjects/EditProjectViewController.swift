//
//  EditProjectViewController.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class EditProjectViewController: UIViewController {
    
    private let projectEditView = ProjectEditView()
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
    
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
    
}
