import UIKit

/*
 TaskEditView - view для отображения на экране Редактирование задачи
 */

class TaskEditView: UIView, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nameTextField = BorderedTextField(placeholder: "Название задачи")
    private let projectPickerView = ProjectPicker(placeholder: "Проект")
    private let employeePickerView = EmployeePicker(placeholder: "Сотрудник")
    private let statusPickerView = StatusPicker(placeholder: "Статус")
    private let requiredNumberOfHoursTextField = TaskHoursTextField(placeholder: "Кол-во часов")
    private let startDatePickerView = DatePickerView()
    private let endDatePickerView = EndDatePicker()
    
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
            nameTextField.bind(task.name)
            requiredNumberOfHoursTextField.bind(String(task.requiredNumberOfHours))
            startDatePickerView.bind(task.startDate)
            endDatePickerView.bind(task.endDate)
            
            let selectedProject = projectItems.first(where: { $0.id == task.project.id })
            projectPickerView.bind(data: projectItems, selectedItem: selectedProject)
            
            let selectedEmployee = employeeItems.first(where: { $0.id == task.employee.id })
            employeePickerView.bind(data: employeeItems, selectedItem: selectedEmployee)
            
            let selectedStatus = statusItems.first(where: { $0.id == task.status.hashValue })
            statusPickerView.bind(data: statusItems, selectedItem: selectedStatus)
        } else {
            let currentDate = Date()
            let endDate = endDatePickerView.getEndDateFrom(startDate: currentDate,
                                                           with: taskDetails.daysBetweenDates ?? 0)
            startDatePickerView.bind(Date())
            endDatePickerView.bind(endDate)
            
            projectPickerView.bind(data: projectItems, selectedItem: nil)
            employeePickerView.bind(data: employeeItems, selectedItem: nil)
            statusPickerView.bind(data: statusItems, selectedItem: nil)
        }
        
        if taskDetails.project != nil {
            blockProjectTextField()
        }
    }
    
    /*
     Метод собирает значения из текстФилдов, проверяет их и собирает задачу
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - собранная модель задачи
     */
    func unbind() throws -> Task {
        let taskName = try Validator.validateTextForMissingValue(text: nameTextField.unbind(),
                                                                 message: "Введите название")
        let project = try projectPickerView.unbindProject()
        let employee = try employeePickerView.unbindEmployee()
        let status = try statusPickerView.unbindStatus()
        let hours = try requiredNumberOfHoursTextField.unbindIntValue()
        let startDate = try startDatePickerView.unbind()
        let endDate = try endDatePickerView.unbind()
        
        guard startDate <= endDate else {
            throw BaseError(message: "Начальная дата не должна быть больше конечной даты")
        }
        let task = Task(name: taskName, project: project, employee: employee, status: status,
                        requiredNumberOfHours: hours, startDate: startDate, endDate: endDate)
        return task
    }
    
    /*
     Метод блокировки projectTextField для редактирования
     */
    private func blockProjectTextField() {
        projectPickerView.isUserInteractionEnabled = false
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
}
