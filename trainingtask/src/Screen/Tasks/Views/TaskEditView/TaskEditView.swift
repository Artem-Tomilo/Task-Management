import UIKit

/*
 TaskEditView - view для отображения на экране Редактирование задачи
 */

class TaskEditView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nameTextField = BorderedTextField(frame: .zero, placeholder: "Название задачи")
    private let projectTextField = BorderedTextField(frame: .zero, placeholder: "Проект")
    private let employeeTextField = BorderedTextField(frame: .zero, placeholder: "Сотрудник")
    private let statusTextField = BorderedTextField(frame: .zero, placeholder: "Статус")
    private let requiredNumberOfHoursTextField = BorderedTextField(frame: .zero, placeholder: "Кол-во часов")
    private let startDateTextField = DatePickerView()
    private let endDateTextField = DatePickerView()
    lazy var picker = TaskPickerView()
    private let dateFormatter = TaskDateFormatter()
    
    weak var delegate: TaskEditViewDelegate?
    
    var isProjectTextField = false // свойство, определяющее был ли нажат projectTextField
    var isEmployeeTextField = false // свойство, определяющее был ли нажат employeeTextField
    var isStatusTextField = false // свойство, определяющее был ли нажат statusTextField
    
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
        
        requiredNumberOfHoursTextField.keyboardType = .numberPad
        startDateTextField.bindText(getStringCurrentDate())
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
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
    func bind(task: Task) {
        nameTextField.bindText(task.name)
        projectTextField.bindText(task.project.name)
        employeeTextField.bindText(task.employee.fullName)
        statusTextField.bindText(getStatusTitleFrom(task.status))
        requiredNumberOfHoursTextField.bindText(String(task.requiredNumberOfHours))
        startDateTextField.bindText(dateFormatter.string(from: task.startDate))
        endDateTextField.bindText(dateFormatter.string(from: task.endDate))
    }
    
    /*
     Метод для заполнения projectTextField данными
     
     parametrs:
     project - проект, данными которого будет заполняться projectTextField
     */
    func bindProjectTextFieldBy(project: Project) {
        projectTextField.bindText(project.name)
    }
    
    /*
     Метод для заполнения endDateTextField данными
     
     parametrs:
     days - количество дней из настроек приложения для определения даты окончания выполнения задачи
     */
    func bindEndDateTextField(days: Int) {
        let date = Date()
        let endDate = dateFormatter.getEndDateFrom(startDate: date, with: days)
        let stringDate = dateFormatter.string(from: endDate)
        endDateTextField.bindText(stringDate)
    }
    
    /*
     Метод получения текста nameTextField и его проверки, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст nameTextField
     */
    func unbindName() throws -> String {
        try Validator.validateTextForMissingValue(text: nameTextField.unbindText(),
                                                  message: "Введите название")
        return nameTextField.unbindText()
    }
    
    /*
     Метод получения текста projectTextField, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст projectTextField
     */
    func unbindProject() throws -> String {
        try Validator.validateTextForMissingValue(text: projectTextField.unbindText(),
                                                  message: "Выберите проект")
        return projectTextField.unbindText()
    }
    
    /*
     Метод получения текста employeeTextField, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - текст employeeTextField
     */
    func unbindEmployee() throws -> String {
        try Validator.validateTextForMissingValue(text: employeeTextField.unbindText(),
                                                  message: "Выберите сотрудника")
        return employeeTextField.unbindText()
    }
    
    /*
     Метод получения текста statusTextField, его проверки и форматирования в тип TaskStatus,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - статус
     */
    func unbindStatus() throws -> TaskStatus {
        let text = statusTextField.unbindText()
        let status = getStatusFrom(text)
        
        try Validator.validateTextForMissingValue(text: text,
                                                  message: "Выберите статус")
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
        let text = requiredNumberOfHoursTextField.unbindText()
        try Validator.validateTextForMissingValue(text: text,
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
        try Validator.validateTextForMissingValue(text: startDateTextField.unbindText(),
                                                  message: "Введите начальную дату")
        if let date = dateFormatter.date(from: startDateTextField.unbindText()) {
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
        try Validator.validateTextForMissingValue(text: endDateTextField.unbindText(),
                                                  message: "Введите конечную дату")
        if let date = dateFormatter.date(from: endDateTextField.unbindText()) {
            return date
        } else {
            throw BaseError(message: "Некоректный ввод конечной даты")
        }
    }
    
    /*
     Метод блокировки projectTextField для редактирования
     */
    func blockProjectTextField() {
        projectTextField.isUserInteractionEnabled = false
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
     Метод вызова PickerView
     
     parameters:
     textField - textField для которого нужен PickerView
     */
    private func showPickerView(textField: BorderedTextField) {
        let data = delegate?.bindData()
        if let data {
            picker.showPicker(textField: textField, data: data)
            textField.becomeFirstResponder()
        }
    }
    
    /*
     Метод получения статуса в строковом варианте
     
     parameters:
     status - статус задачи
     Возвращаемое значение - строковый вариант статуса
     */
    func getStatusTitleFrom(_ status: TaskStatus) -> String {
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
     Target на тап projectTextField
     */
    @objc func projectTapped(_ sender: UITapGestureRecognizer) {
        isProjectTextField = true
        showPickerView(textField: projectTextField)
        isProjectTextField = false
    }
    
    /*
     Target на тап employeeTextField
     */
    @objc func employeeTapped(_ sender: UITapGestureRecognizer) {
        isEmployeeTextField = true
        showPickerView(textField: employeeTextField)
        isEmployeeTextField = false
    }
    
    /*
     Target на тап statusTextField
     */
    @objc func statusTapped(_ sender: UITapGestureRecognizer) {
        isStatusTextField = true
        showPickerView(textField: statusTextField)
        isStatusTextField = false
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
