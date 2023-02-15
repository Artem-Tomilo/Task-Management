import UIKit

/*
 TaskEditView - view для отображения на экране Редактирование задачи
 */

class TaskEditView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nameTextField = BorderedTextField(placeholder: "Название задачи")
    private let projectPickerView = ProjectPicker(placeholder: "Проект")
    private let employeePickerView = EmployeePicker(placeholder: "Сотрудник")
    private let statusPickerView = StatusPicker(placeholder: "Статус")
    private let requiredNumberOfHoursTextField = BorderedTextField(placeholder: "Кол-во часов")
    private let startDatePickerView = DatePickerView()
    private let endDatePickerView = DatePickerView()
    private let dateFormatter = TaskDateFormatter()
    
    private var projects = [Project]()
    private var employees = [Employee]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        addingAndSetupSubviews()
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
        stackView.addArrangedSubview(projectPickerView)
        stackView.addArrangedSubview(employeePickerView)
        stackView.addArrangedSubview(statusPickerView)
        stackView.addArrangedSubview(requiredNumberOfHoursTextField)
        stackView.addArrangedSubview(startDatePickerView)
        stackView.addArrangedSubview(endDatePickerView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        requiredNumberOfHoursTextField.delegate = self
        requiredNumberOfHoursTextField.keyboardType = .numberPad
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    /*
     Метод вызова FirstResponder при загрузке view
     */
    func initFirstResponder() {
        nameTextField.becomeFirstResponder()
    }
    
    /*
     Метод для заполнения текущего view данными
     
     parametrs:
     task - задача, данными которой будут заполняться текстФилды
     */
    func bind(taskDetails: TaskDetails) {
        projects = taskDetails.listProjects ?? []
        employees = taskDetails.listEmployees ?? []
        let projectItems = projectPickerView.setData(projects)
        let employeeItems = employeePickerView.setData(employees)
        let statusItems = statusPickerView.setData()
        
        if let task = taskDetails.task {
            nameTextField.bindText(task.name)
            requiredNumberOfHoursTextField.bindText(String(task.requiredNumberOfHours))
            startDatePickerView.bindText(dateFormatter.string(from: task.startDate))
            endDatePickerView.bindText(dateFormatter.string(from: task.endDate))
            
            let selectedProject = projectItems.first(where: { $0.id == task.project.id })
            projectPickerView.bind(data: projectItems, selectedItem: selectedProject)
            
            let selectedEmployee = employeeItems.first(where: { $0.id == task.employee.id })
            employeePickerView.bind(data: employeeItems, selectedItem: selectedEmployee)
            
            let selectedStatus = statusItems.first(where: { $0.id == task.status.hashValue })
            statusPickerView.bind(data: statusItems, selectedItem: selectedStatus)
        } else {
            startDatePickerView.bindText(getStringCurrentDate())
            
            let date = Date()
            let endDate = dateFormatter.getEndDateFrom(startDate: date, with: taskDetails.daysBetweenDates ?? 0)
            let stringDate = dateFormatter.string(from: endDate)
            endDatePickerView.bindText(stringDate)
            
            projectPickerView.bind(data: projectItems, selectedItem: nil)
            employeePickerView.bind(data: employeeItems, selectedItem: nil)
            statusPickerView.bind(data: statusItems, selectedItem: nil)
        }
        
        if taskDetails.project != nil {
            blockProjectTextField()
        }
    }
    
    func unbind() throws {
        let taskName = try Validator.validateTextForMissingValue(text: nameTextField.unbindText(),
                                                                 message: "Введите название")
        let project = try projectPickerView.unbindProject()
        print(project)
        let employee = try employeePickerView.unbindEmployee()
        print(employee)
        let status = try statusPickerView.unbindStatus()
        print(status)
        
    }
    
    /*
     Метод получения текста requiredNumberOfHoursTextField, его проверки и форматирования в числовой формат,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - числовое значение текста requiredNumberOfHoursTextField
     */
    func unbindHours() throws -> Int {
        let text = try Validator.validateTextForMissingValue(text: requiredNumberOfHoursTextField.unbindText(),
                                                             message: "Введите количество часов для выполнения задачи")
        
        let hours = try Validator.validateAndReturnTextForIntValue(text: text,
                                                                   message: "Введено некорректное количество часов")
        guard hours > 0 else {
            throw BaseError(message: "Количество часов должно быть больше 0")
        }
        return hours
    }
    
    /*
     Метод получения текста startDateTextField, его проверки и форматирования в формат даты,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - начальная дата
     */
    func unbindStartDate() throws -> Date {
        let text = try Validator.validateTextForMissingValue(text: startDatePickerView.unbindText(),
                                                             message: "Введите начальную дату")
        if let date = dateFormatter.date(from: text) {
            return date
        } else {
            throw BaseError(message: "Некоректный ввод начальной даты")
        }
    }
    
    /*
     Метод получения текста endDateTextField, его проверки и форматирования в формат даты,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - конечная дата
     */
    func unbindEndDate() throws -> Date {
        let text = try Validator.validateTextForMissingValue(text: endDatePickerView.unbindText(),
                                                             message: "Введите конечную дату")
        if let date = dateFormatter.date(from: text) {
            return date
        } else {
            throw BaseError(message: "Некоректный ввод конечной даты")
        }
    }
    
    /*
     Метод блокировки projectTextField для редактирования
     */
    private func blockProjectTextField() {
        projectPickerView.isUserInteractionEnabled = false
    }
    
    /*
     Метод получения текущей даты и перевод ее в строку
     
     Возвращаемое значение - текущая дата
     */
    private func getStringCurrentDate() -> String {
        let date = Date()
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    /*
     Target для scrollView при появлении клавиатуры
     */
    @objc func keyboardFrame(_ notification: NSNotification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as! CGRect
        let keyboardSize = frame.height - keyboardFrame.minY
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize + 80, right: 0)
    }
    
    /*
     Метод UIGestureRecognizerDelegate
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     Метод UITextFieldDelegate для проверки вводимых даннх
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == requiredNumberOfHoursTextField {
            return string.allSatisfy {
                $0.isNumber
            }
        }
        return true
    }
}
