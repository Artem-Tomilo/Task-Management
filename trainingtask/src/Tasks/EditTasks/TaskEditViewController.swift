import UIKit

/*
 TaskEditViewController - экран Редактирование задачи, отображает необходимые поля для введения новой, либо редактирования существующей задачи
 */

class TaskEditViewController: UIViewController, TaskEditViewDelegate {
    
    private let taskEditView = TaskEditView()
    private var projects: [Project] = []
    private var employees: [Employee] = []
    private var status = TaskStatus.allCases
    private var data = [String]()
    private let dateFormatter = TaskDateFormatter()
    private let alertController = Alert()
    
    var possibleTaskToEdit: Task? // свойство, в которое будет записываться передаваемая задача для редактирования
    var project: Project? // если свойство имеет значение, то текстФилд с проектом будет недоступен для редактирования
    
    weak var delegate: TaskEditViewControllerDelegate? // объект делегата для TaskEditViewControllerDelegate
    private let serverDelegate: Server
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager, serverDelegate: Server) {
        self.settingsManager = settingsManager
        self.serverDelegate = serverDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getProjects()
        getEmployees()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskEditView.initFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(taskEditView)
        
        NSLayoutConstraint.activate([
            taskEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            taskEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            taskEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let taskToEdit = possibleTaskToEdit {
            title = "Редактирование задачи"
            taskEditView.bind(task: taskToEdit)
        } else {
            let numbersOfDays = getNumberOfDaysBetweenDates()
            taskEditView.bindEndDateTextField(days: numbersOfDays)
            title = "Добавление задачи"
        }
        
        if let project {
            taskEditView.bindProjectTextFieldBy(project: project)
            taskEditView.blockProjectTextField()
        }
        
        taskEditView.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод получает списов проектов с сервера
     */
    private func getProjects() {
        serverDelegate.getProjects({ [weak self] projects in
            guard let self = self else { return }
            self.projects = projects
        })
    }
    
    /*
     Метод получает списов сотрудников с сервера
     */
    private func getEmployees() {
        serverDelegate.getEmployees({ [weak self] employees in
            guard let self = self else { return }
            self.employees = employees
        })
    }
    
    /*
     Метод привязывает названия проектов в массив для отображения в PickerView
     */
    private func setDataFromProjects() {
        data.removeAll()
        for i in projects {
            data.append(i.name)
        }
    }
    
    /*
     Метод привязывает полное ФИО сотрудников в массив для отображения в PickerView
     */
    private func setDataFromEmployees() {
        data.removeAll()
        for i in employees {
            data.append(i.fullName)
        }
    }
    
    /*
     Метод привязывает названия статусов задачи в массив для отображения в PickerView
     */
    private func setDataFromStatus() {
        data.removeAll()
        for i in TaskStatus.allCases {
            data.append(i.title)
        }
    }
    
    /*
     Метод получение значения количество дней по умолчанию между начальной и конечной датами в задаче из настроек приложения
     */
    private func getNumberOfDaysBetweenDates() -> Int {
        guard let count = try? settingsManager.getSettings().maxDays else { return 0 }
        return count
    }
    
    /*
     Метод проверки введенных значений, если значение не введено - будет выбрасываться соответствующая ошибка
     */
    private func validationOfEnteredData() throws {
        guard taskEditView.unbindName() != "" else {
            throw TaskEditingErrors.noName
        }
        guard taskEditView.unbindProject() != "" else {
            throw TaskEditingErrors.noProject
        }
        guard taskEditView.unbindEmployee() != "" else {
            throw TaskEditingErrors.noEmployee
        }
        guard taskEditView.unbindStatus() != "" else {
            throw TaskEditingErrors.noStatus
        }
        guard taskEditView.unbindHours() != "" else {
            throw TaskEditingErrors.noRequiredNumberOfHours
        }
        guard taskEditView.unbindHours() != "0" else {
            throw TaskEditingErrors.wrongHours
        }
        guard taskEditView.unbindStartDate() != "" else {
            throw TaskEditingErrors.noStartDate
        }
        guard taskEditView.unbindEndDate() != "" else {
            throw TaskEditingErrors.noEndDate
        }
    }
    
    /*
     Метод получает данные из текстФилдов экрана и проверяет на правильность заполнения и собирает модель задачи, если значение введено неверно - будет выбрасываться соответствующая ошибка, в случае ошибки происходит ее обработка
     
     Возвращаемое значение - задача
     */
    private func bindingAndCheckingValues() throws -> Task? {
        do {
            try validationOfEnteredData()
            let name = taskEditView.unbindName()
            let project = taskEditView.unbindProject()
            let employee = taskEditView.unbindEmployee()
            let status = taskEditView.unbindStatus()
            let hours = taskEditView.unbindHours()
            let startDate = taskEditView.unbindStartDate()
            let endDate = taskEditView.unbindEndDate()
            
            guard let taskProject = projects.first(where: { $0.name == project }) else {
                throw ProjectStubErrors.noSuchProject
            }
            guard let taskEmployee = employees.first(where: { $0.fullName == employee }) else {
                throw EmployeeStubErrors.noSuchEmployee
            }
            guard let taskStatus = TaskStatus.allCases.first(where: { $0.title == status }) else {
                throw TaskEditingErrors.noSuchStatus
            }
            guard let hours = Int(hours) else {
                throw TaskEditingErrors.wrongHours
            }
            guard let startDate = dateFormatter.date(from: startDate) else {
                throw TaskEditingErrors.wrongStartDate
            }
            guard let endDate = dateFormatter.date(from: endDate) else {
                throw TaskEditingErrors.wrongEndDate
            }
            guard startDate <= endDate else {
                throw TaskEditingErrors.startDateGreaterEndDate
            }
            
            let task = Task(name: name, project: taskProject, employee: taskEmployee, status: taskStatus, requiredNumberOfHours: hours, startDate: startDate, endDate: endDate)
            return task
        } catch {
            handleError(error: error)
        }
        return nil
    }
    
    /*
     Метод, который привязывает новые данные для редактируемой задачи, в случае ошибки происходит ее обработка
     
     parameters:
     editedTask - редактируемая задача
     */
    private func editingTask(editedTask: Task) {
        do {
            if let task = try bindingAndCheckingValues() {
                var newTask = editedTask
                newTask.name = task.name
                newTask.project = task.project
                newTask.employee = task.employee
                newTask.status = task.status
                newTask.requiredNumberOfHours = task.requiredNumberOfHours
                newTask.startDate = task.startDate
                newTask.endDate = task.endDate
                
                delegate?.editTask(self, editedTask: newTask)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    /*
     Метод, который создает новую задачу, в случае ошибки происходит ее обработка
     */
    private func createNewTask() {
        do {
            if let task = try bindingAndCheckingValues() {
                delegate?.addNewTask(self, newTask: task)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(error: Error) {
        let taskError = error as! TaskEditingErrors
        alertController.showAlertController(message: taskError.message, viewController: self)
    }
    
    /*
     Метод, который проверяет и сохраняет либо новую, либо отредактированную задачу
     */
    private func saveTask() {
        if let editedTask = possibleTaskToEdit {
            editingTask(editedTask: editedTask)
        } else {
            createNewTask()
        }
    }
    
    /*
     Target на кнопку Save - вызывает метод saveTask()
     */
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        saveTask()
    }
    
    /*
     Target на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.addTaskDidCancel(self)
    }
    
    /*
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
    
    /*
     Метод протокола TaskEditViewDelegate, который проверяет какие данные нужны и записывает ими массив
     
     Возвращаемое значение: массив данных
     */
    func bindData() -> [String] {
        if taskEditView.isProjectTextField {
            setDataFromProjects()
        }
        
        if taskEditView.isEmployeeTextField {
            setDataFromEmployees()
        }
        
        if taskEditView.isStatusTextField {
            setDataFromStatus()
        }
        return data
    }
}
