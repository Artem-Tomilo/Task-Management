//
//  TaskEditView.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskEditView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    private let nameTextField = BorderedTextField()
    private let projectTextField = BorderedTextField()
    private let employeeTextField = BorderedTextField()
    private let statusTextField = BorderedTextField()
    private let requiredNumberOfHoursTextField = BorderedTextField()
    private let startDateTextField = BorderedTextField()
    private let endDateTextField = BorderedTextField()
    private let datePicker = TaskDatePicker()
    lazy var picker = TaskPickerView()
    private let dateFormatter = TaskDateFormatter()
    
    weak var delegate: TaskEditViewDelegate?
    
    var isProjectTextField = false
    var isEmployeeTextField = false
    var isStatusTextField = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        initTapGesture()
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
        
        requiredNumberOfHoursTextField.keyboardType = .numberPad
        startDateTextField.text = currentDate()
    }
    
    private func initTapGesture() {
        let projectGesture = UITapGestureRecognizer(target: self, action: #selector(projectTapped(_:)))
        projectTextField.addGestureRecognizer(projectGesture)
        projectTextField.isUserInteractionEnabled = true
        
        let employeeGesture = UITapGestureRecognizer(target: self, action: #selector(employeeTapped(_:)))
        employeeTextField.addGestureRecognizer(employeeGesture)
        employeeTextField.isUserInteractionEnabled = true
        
        let statusGesture = UITapGestureRecognizer(target: self, action: #selector(statusTapped(_:)))
        statusTextField.addGestureRecognizer(statusGesture)
        statusTextField.isUserInteractionEnabled = true
        
        let startDateGesture = UITapGestureRecognizer(target: self, action: #selector(startDateTapped(_:)))
        startDateTextField.addGestureRecognizer(startDateGesture)
        startDateTextField.isUserInteractionEnabled = true
        
        let endDateGesture = UITapGestureRecognizer(target: self, action: #selector(endDateTapped(_:)))
        endDateTextField.addGestureRecognizer(endDateGesture)
        endDateTextField.isUserInteractionEnabled = true
    }
    
    func bind(task: Task) {
        nameTextField.text = task.name
        projectTextField.text = task.project.name
        employeeTextField.text = "\(task.employee.surname) \(task.employee.name) \(task.employee.patronymic)"
        statusTextField.text = task.status.title
        requiredNumberOfHoursTextField.text = String(task.requiredNumberOfHours)
        startDateTextField.text = dateFormatter.string(from: task.startDate)
        endDateTextField.text = dateFormatter.string(from: task.endDate)
    }
    
    func bindProjectTextFieldBy(project: Project) {
        projectTextField.text = project.name
    }
    
    private func checkValue(in textField: BorderedTextField) -> String {
        let text = textField.text
        if let text  {
            return text
        }
        return ""
    }
    
    func unbindName() -> String {
        let name = checkValue(in: nameTextField)
        return name
    }
    
    func unbindProject() -> String {
        let project = checkValue(in: projectTextField)
        return project
    }
    
    func unbindEmployee() -> String {
        let employee = checkValue(in: employeeTextField)
        return employee
    }
    
    func unbindStatus() -> String {
        let status = checkValue(in: statusTextField)
        return status
    }
    
    func unbindHours() -> String {
        let hours = checkValue(in: requiredNumberOfHoursTextField)
        return hours
    }
    
    func unbindStartDate() -> String {
        let startDate = checkValue(in: startDateTextField)
        return startDate
    }
    
    func unbindEndDate() -> String {
        let endDate = checkValue(in: endDateTextField)
        return endDate
    }
    
    func bindEndDateTextField(days: Int) {
        let date = Date()
        let endDate = dateFormatter.getEndDateFromNumberOfDaysBetweenDates(date: date, days: days)
        let stringDate = dateFormatter.string(from: endDate)
        endDateTextField.text = stringDate
    }
    
    func initFirstResponder() {
        nameTextField.becomeFirstResponder()
    }
    
    func blockProjectTextField() {
        projectTextField.isUserInteractionEnabled = false
    }
    
    private func currentDate() -> String {
        let date = Date()
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    private func showPickerView(textField: BorderedTextField) {
        let data = delegate?.bindData()
        if let data {
            picker.showPicker(textField: textField, data: data)
            textField.becomeFirstResponder()
        }
    }
    
    private func showDatePicker(textField: BorderedTextField) {
        datePicker.showDatePicker(textField: textField)
    }
    
    @objc func projectTapped(_ sender: UITapGestureRecognizer) {
        isProjectTextField = true
        showPickerView(textField: projectTextField)
        isProjectTextField = false
    }
    
    @objc func employeeTapped(_ sender: UITapGestureRecognizer) {
        isEmployeeTextField = true
        showPickerView(textField: employeeTextField)
        isEmployeeTextField = false
    }
    
    @objc func statusTapped(_ sender: UITapGestureRecognizer) {
        isStatusTextField = true
        showPickerView(textField: statusTextField)
        isStatusTextField = false
    }
    
    @objc func startDateTapped(_ sender: UITapGestureRecognizer) {
        showDatePicker(textField: startDateTextField)
    }
    
    @objc func endDateTapped(_ sender: UITapGestureRecognizer) {
        showDatePicker(textField: endDateTextField)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == requiredNumberOfHoursTextField {
            return string.allSatisfy {
                $0.isNumber
            }
        }
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case nameTextField:
//            isProjectTextField = true
//            showPickerView(textField: projectTextField)
//            isProjectTextField = false
//            projectTextField.becomeFirstResponder()
//        case projectTextField:
//            showPickerView(textField: employeeTextField)
//            employeeTextField.becomeFirstResponder()
//        case employeeTextField:
//            showPickerView(textField: statusTextField)
//            statusTextField.becomeFirstResponder()
//        case statusTextField:
//            requiredNumberOfHoursTextField.becomeFirstResponder()
//        case requiredNumberOfHoursTextField:
//            startDateTextField.becomeFirstResponder()
//        case startDateTextField:
//            endDateTextField.becomeFirstResponder()
//        case endDateTextField:
//            endDateTextField.resignFirstResponder()
//        default:
//            break
//        }
//        return true
//    }
}
