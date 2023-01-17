import UIKit

/*
 TaskEditViewController - экран Редактирование задачи,
 отображает необходимые поля для введения новой, либо редактирования существующей задачи
 */

class TaskEditViewController: UIViewController {
    
    private let taskEditView = TaskEditView()
    private let spinnerView = SpinnerView()
    
    var possibleTaskToEdit: Task? // свойство, в которое будет записываться передаваемая задача для редактирования
    var project: Project? // если свойство имеет значение, то текстФилд с проектом будет недоступен для редактирования
    
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
            taskEditView.bind(task: taskToEdit, projects: nil, employees: nil, project: nil, days: nil)
        } else {
            let numbersOfDays = getNumberOfDaysBetweenDates()
            taskEditView.bind(task: nil, projects: nil, employees: nil, project: nil, days: numbersOfDays)
            title = "Добавление задачи"
        }
        
        if let project {
            taskEditView.bind(task: nil, projects: nil, employees: nil, project: project, days: nil)
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveEmployeeButtonTapped(_:)))
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
            self.taskEditView.bind(task: nil, projects: projects, employees: nil, project: nil, days: nil)
        }) { [weak self] error in
            guard let self = self else { return }
            self.handleError(error: error)
        }
    }
    
    /*
     Метод получает списов сотрудников с сервера
     */
    private func getEmployees() {
        serverDelegate.getEmployees({ [weak self] employees in
            guard let self = self else { return }
            self.taskEditView.bind(task: nil, projects: nil, employees: employees, project: nil, days: nil)
        }) { [weak self] error in
            guard let self = self else { return }
            self.handleError(error: error)
        }
    }
    
    /*
     Метод получения значения количества дней по умолчанию между начальной и конечной датами в задаче из настроек приложения
     */
    private func getNumberOfDaysBetweenDates() -> Int {
        return settingsManager.getSettings().maxDays
    }
    
    /*
     Метод получает данные из текстФилдов экрана, делает валидацию и собирает модель задачи,
     при редактировании заменяет данные редактирумой задачи новыми данными
     
     Возвращаемое значение - задача
     */
    private func unbind() throws -> Task {
        let name = try taskEditView.unbindName()
        let project = try taskEditView.unbindProject()
        let employee = try taskEditView.unbindEmployee()
        let status = try taskEditView.unbindStatus()
        let hours = try taskEditView.unbindHours()
        let startDate = try taskEditView.unbindStartDate()
        let endDate = try taskEditView.unbindEndDate()
        
        guard startDate <= endDate else {
            throw BaseError(message: "Начальная дата не должна быть больше конечной даты")
        }
        
        var task = Task(name: name, project: project, employee: employee,
                        status: status, requiredNumberOfHours: hours, startDate: startDate, endDate: endDate)
        if let possibleTaskToEdit {
            task.id = possibleTaskToEdit.id
        }
        return task
    }
    
    /*
     Метод добавляет новую задачу в массив на сервере и возвращает на экран Список задач,
     в случае ошибки происходит ее обработка
     
     parameters:
     newTask - новая задача для добавления
     */
    private func addingNewTaskOnServer(_ newTask: Task) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.addTask(task: newTask) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner(from: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner(from: self)
                self.handleError(error: error)
            }
        }
    }
    
    /*
     Метод изменяет данные задачи на сервере, в случае ошибки происходит ее обработка
     
     parameters:
     editedTask - изменяемая задача
     */
    private func editingTaskOnServer(_ editedTask: Task) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.editTask(id: editedTask.id, editedTask: editedTask) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner(from: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner(from: self)
                self.handleError(error: error)
            }
        }
    }
    
    /*
     Метод, который проверяет и сохраняет либо новый, либо отредактированный проект,
     в случае ошибки происходит ее обработка
     */
    private func saveTask() throws {
        let bindedTask = try unbind()
        if possibleTaskToEdit != nil {
            editingTaskOnServer(bindedTask)
        } else {
            addingNewTaskOnServer(bindedTask)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(error: Error) {
        let taskError = error as! BaseError
        ErrorAlert.showAlertController(message: taskError.message, viewController: self)
    }
    
    /*
     Target на кнопку Save - вызывает метод saveTask()
     */
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try saveTask()
        } catch {
            handleError(error: error)
        }
    }
    
    /*
     Target на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
