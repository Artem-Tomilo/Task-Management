//
//  TaskEditView.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskEditView: UIView, UITextFieldDelegate {
    private let nameTextField: BorderedTextField
    private let projectTextField: BorderedTextField
    private let employeeTextField: BorderedTextField
    private let statusTextField: BorderedTextField
    private let requiredNumberOfHoursTextField: BorderedTextField
    private let startDateTextField: BorderedTextField
    private let endDateTextField: BorderedTextField
    
    override init(frame: CGRect) {
        self.nameTextField = BorderedTextField()
        self.projectTextField = BorderedTextField()
        self.employeeTextField = BorderedTextField()
        self.statusTextField = BorderedTextField()
        self.requiredNumberOfHoursTextField = BorderedTextField()
        self.startDateTextField = BorderedTextField()
        self.endDateTextField = BorderedTextField()
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameTextField)
        addSubview(projectTextField)
        addSubview(employeeTextField)
        addSubview(statusTextField)
        addSubview(requiredNumberOfHoursTextField)
        addSubview(startDateTextField)
        addSubview(endDateTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            projectTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            projectTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            projectTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            employeeTextField.topAnchor.constraint(equalTo: projectTextField.bottomAnchor, constant: 50),
            employeeTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            employeeTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            statusTextField.topAnchor.constraint(equalTo: employeeTextField.bottomAnchor, constant: 50),
            statusTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            requiredNumberOfHoursTextField.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 50),
            requiredNumberOfHoursTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            requiredNumberOfHoursTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            startDateTextField.topAnchor.constraint(equalTo: requiredNumberOfHoursTextField.bottomAnchor, constant: 50),
            startDateTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            startDateTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            endDateTextField.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: 50),
            endDateTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            endDateTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        nameTextField.delegate = self
        projectTextField.delegate = self
        employeeTextField.delegate = self
        statusTextField.delegate = self
        requiredNumberOfHoursTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        nameTextField.placeholder = "Название задачи"
        projectTextField.placeholder = "Проект"
        employeeTextField.placeholder = "Сотрудник"
        statusTextField.placeholder = "Статус"
        requiredNumberOfHoursTextField.placeholder = "Кол-во часов"
        startDateTextField.placeholder = "Дата начала"
        endDateTextField.placeholder = "Дата окончания"
        
        nameTextField.becomeFirstResponder()
    }
    
    func bind(nameTextFieldText: String, projectTextFieldText: String/*, employeeTextFieldText: String, statusTextFieldText: String,                  requiredNumberOfHoursTextFieldText: String, startDateTextFieldText: String, endDateTextFieldText: String*/) {
        nameTextField.text = nameTextFieldText
        projectTextField.text = projectTextFieldText
    }
    
//    func unbind() -> (String, String) {
//        if let name = nameTextField.text,
//           let description = descriptionTextField.text {
//            return (name, description)
//        }
//        return ("No data", "No data")
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            projectTextField.becomeFirstResponder()
        case projectTextField:
            employeeTextField.becomeFirstResponder()
        case employeeTextField:
            statusTextField.becomeFirstResponder()
        case statusTextField:
            requiredNumberOfHoursTextField.becomeFirstResponder()
        case requiredNumberOfHoursTextField:
            startDateTextField.becomeFirstResponder()
        case startDateTextField:
            endDateTextField.becomeFirstResponder()
        case endDateTextField:
            endDateTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
