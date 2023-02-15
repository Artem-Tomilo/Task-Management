import UIKit

/*
 TaskEditView - view для отображения на экране Редактирование задачи
 */

class TaskEditView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nameTextField = BorderedTextField(placeholder: "Название задачи")
    private let projectPickerView = PickerView(placeholder: "Проект")
    private let employeePickerView = PickerView(placeholder: "Сотрудник")
    private let statusPickerView = PickerView(placeholder: "Статус")
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
        let projectItems = setData(projects)
        let employeeItems = setData(employees)
        let statusItems = setData(TaskStatus.allCases)
        
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
    
    /*
     Метод получения текста nameTextField и его проверки, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст nameTextField
     */
    func unbindName() throws -> String {
        return try Validator.validateTextForMissingValue(text: nameTextField.unbindText(),
                                                         message: "Введите название")
    }
    
    /*
     Метод получения текста projectTextField, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст projectTextField
     */
    func unbindProject() throws -> Project {
        let project = try Validator.validateTextForMissingValue(text: projectPickerView.unbindText(),
                                                                message: "Выберите проект")
        guard let taskProject = projects.first(where: { $0.name == project }) else {
            throw BaseError(message: "Не удалось получить проект")
        }
        return taskProject
    }
    
    /*
     Метод получения текста employeeTextField, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст employeeTextField
     */
    func unbindEmployee() throws -> Employee {
        let employee = try Validator.validateTextForMissingValue(text: employeePickerView.unbindText(),
                                                                 message: "Выберите сотрудника")
        guard let taskEmployee = employees.first(where: { $0.fullName == employee }) else {
            throw BaseError(message: "Не удалось получить сотрудника")
        }
        return taskEmployee
    }
    
    /*
     Метод получения текста statusTextField, его проверки и форматирования в тип TaskStatus,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - статус
     */
    func unbindStatus() throws -> TaskStatus {
        let text = try Validator.validateTextForMissingValue(text: statusPickerView.unbindText(),
                                                             message: "Выберите статус")
        let status = getStatusFrom(text)
        guard let status = TaskStatus.allCases.first(where: { $0 == status }) else {
            throw BaseError(message: "Не удалось выбрать статус")
        }
        return status
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
     Метод привязывает названия проектов в массив для отображения в PickerView
     */
    private func setData(_ data: [Any]) -> [PickerViewItem] {
        var pickerViewData = [PickerViewItem]()
        if data is [Project] {
            for i in data {
                let project = i as! Project
                let item = PickerViewItem(id: project.id, title: project.name)
                pickerViewData.append(item)
            }
        } else if data is [Employee] {
            for i in data {
                let employee = i as! Employee
                let item = PickerViewItem(id: employee.id, title: employee.fullName)
                pickerViewData.append(item)
            }
        } else if data is TaskStatus.AllCases {
            for i in data {
                let status = i as! TaskStatus
                let item = PickerViewItem(id: status.hashValue, title: getStatusTitleFrom(status))
                pickerViewData.append(item)
            }
        }
        return pickerViewData
    }
    
    /*
     Метод получения статуса в строковом варианте
     
     parameters:
     status - статус задачи
     Возвращаемое значение - строковый вариант статуса
     */
    private func getStatusTitleFrom(_ status: TaskStatus) -> String {
        switch status {
        case .notStarted:
            return "Не начата"
        case .inProgress:
            return "В процессе"
        case .completed:
            return "Завершена"
        case .postponed:
            return "Отложена"
        }
    }
    
    /*
     Метод получения статуса из строки
     
     parameters:
     title - проверяемая строка
     Возвращаемое значение - статус
     */
    private func getStatusFrom(_ title: String) -> TaskStatus? {
        switch title {
        case "Не начата":
            return .notStarted
        case "В процессе":
            return .inProgress
        case "Завершена":
            return .completed
        case "Отложена":
            return .postponed
        default:
            return nil
        }
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
