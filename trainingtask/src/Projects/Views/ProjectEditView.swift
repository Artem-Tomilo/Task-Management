//
//  ProjectEditView.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import UIKit

class ProjectEditView: UIView, UITextFieldDelegate {
    
    private let nameTextField: BorderedTextField
    private let descriptionTextField: BorderedTextField
    
    override init(frame: CGRect) {
        self.nameTextField = BorderedTextField()
        self.descriptionTextField = BorderedTextField()
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameTextField)
        addSubview(descriptionTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            descriptionTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameTextField.placeholder = "Название"
        descriptionTextField.placeholder = "Описание"
        
        nameTextField.becomeFirstResponder()
    }
    
    func bind(nameTextFieldText: String, descriptionTextFieldText: String) {
        nameTextField.text = nameTextFieldText
        descriptionTextField.text = descriptionTextFieldText
    }
    
    func unbind() -> (String, String) {
        if let name = nameTextField.text,
           let description = descriptionTextField.text {
            return (name, description)
        }
        return ("No data", "No data")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
            descriptionTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

