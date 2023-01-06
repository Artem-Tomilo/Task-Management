//
//  TaskEditView.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import UIKit

class TaskEditView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
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
        setupScrollView()
        addingAndSetupSubviews()
        initTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        stackView.axis = .vertical
        stackView.spacing = 50
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func addingAndSetupSubviews() {
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(projectTextField)
        stackView.addArrangedSubview(employeeTextField)
        stackView.addArrangedSubview(statusTextField)
        stackView.addArrangedSubview(requiredNumberOfHoursTextField)
        stackView.addArrangedSubview(startDateTextField)
        stackView.addArrangedSubview(endDateTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
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
        startDateTextField.keyboardType = .numberPad
        endDateTextField.keyboardType = .numberPad
        startDateTextField.text = currentDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    func initFirstResponder() {
        nameTextField.becomeFirstResponder()
    }
    
    func bind(task: Task) {
        nameTextField.text = task.name
        projectTextField.text = task.project.name
        employeeTextField.text = task.employee.fullName
        statusTextField.text = task.status.title
        requiredNumberOfHoursTextField.text = String(task.requiredNumberOfHours)
        startDateTextField.text = dateFormatter.string(from: task.startDate)
        endDateTextField.text = dateFormatter.string(from: task.endDate)
    }
    
    func bindProjectTextFieldBy(project: Project) {
        projectTextField.text = project.name
    }
    
    func bindEndDateTextField(days: Int) {
        let date = Date()
        let endDate = dateFormatter.getEndDateFromNumberOfDaysBetweenDates(date: date, days: days)
        let stringDate = dateFormatter.string(from: endDate)
        endDateTextField.text = stringDate
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
    
    @objc func keyboardFrame(_ notification: NSNotification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as! CGRect
        let keyboardSize = frame.height - keyboardFrame.minY
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize + 80, right: 0)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func formatDate(date: String) -> String {
        let cleanDate = date.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXX-XX-XX"
        var result = ""
        var index = cleanDate.startIndex
        
        for ch in mask where index < cleanDate.endIndex {
            if ch == "X" {
                result.append(cleanDate[index])
                index = cleanDate.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == requiredNumberOfHoursTextField {
            return string.allSatisfy {
                $0.isNumber
            }
        }
        
        if textField == startDateTextField || textField == endDateTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formatDate(date: newString)
            return false
        }
        return true
    }
}
