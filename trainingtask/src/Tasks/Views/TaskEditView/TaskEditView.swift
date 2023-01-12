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
    private let startDateTextField = BorderedTextField(frame: .zero, placeholder: "Дата начала")
    private let endDateTextField = BorderedTextField(frame: .zero, placeholder: "Дата окончания")
    private let datePicker = TaskDatePicker()
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
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
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
        statusTextField.bindText(task.status.title)
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
        let endDate = dateFormatter.getEndDateFromNumberOfDaysBetweenDates(date: date, days: days)
        let stringDate = dateFormatter.string(from: endDate)
        endDateTextField.bindText(stringDate)
    }
    
    /*
     Метод получения текста nameTextField
     
     Возвращаемое значение - текст nameTextField
     */
    func unbindName() -> String {
        return nameTextField.unbindText()
    }
    
    /*
     Метод получения текста projectTextField
     
     Возвращаемое значение - текст projectTextField
     */
    func unbindProject() -> String {
        return projectTextField.unbindText()
    }
    
    /*
     Метод получения текста employeeTextField
     
     Возвращаемое значение - текст employeeTextField
     */
    func unbindEmployee() -> String {
        return employeeTextField.unbindText()
    }
    
    /*
     Метод получения текста statusTextField
     
     Возвращаемое значение - текст statusTextField
     */
    func unbindStatus() -> String {
        return statusTextField.unbindText()
    }
    
    /*
     Метод получения текста requiredNumberOfHoursTextField
     
     Возвращаемое значение - текст requiredNumberOfHoursTextField
     */
    func unbindHours() -> String {
        return requiredNumberOfHoursTextField.unbindText()
    }
    
    /*
     Метод получения текста startDateTextField
     
     Возвращаемое значение - текст startDateTextField
     */
    func unbindStartDate() -> String {
        return startDateTextField.unbindText()
    }
    
    /*
     Метод получения текста endDateTextField
     
     Возвращаемое значение - текст endDateTextField
     */
    func unbindEndDate() -> String {
        return endDateTextField.unbindText()
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
    private func currentDate() -> String {
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
     Метод вызова DatePicker
     
     parameters:
     textField - textField для которого нужен DatePicker
     */
    private func showDatePicker(textField: BorderedTextField) {
        datePicker.showDatePicker(textField: textField)
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
     Target на тап startDateTextField
     */
    @objc func startDateTapped(_ sender: UITapGestureRecognizer) {
        showDatePicker(textField: startDateTextField)
    }
    
    /*
     Target на тап endDateTextField
     */
    @objc func endDateTapped(_ sender: UITapGestureRecognizer) {
        showDatePicker(textField: endDateTextField)
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     Метод для создания маски при вводе даты с клавиатуры
     
     parameters:
     date - текст textField
     */
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
    
    /*
     Метод UITextFieldDelegate для проверки вводимых даннх
     */
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
