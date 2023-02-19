import UIKit

/**
 Экран Редактирование задачи, отображает необходимые поля для введения новой, либо редактирования существующей задачи
 */
class TaskEditViewController: UIViewController {
    
    private let taskEditView = TaskEditView()
    private let spinnerView = SpinnerView()
    
    /**
     Модель, в которую будут записываться данные для TaskEditView
     */
    private var taskBindModel = TaskBindModel()
    
    /**
     Свойство, в которое будет записываться передаваемая задача для редактирования
     */
    private var possibleTaskToEdit: Task?
    
    /**
     Свойство, в котором хранится проект, с которого был осуществлен переход на экран
     Если оно имеет значение, то текстФилд с проектом будет недоступен для редактирования
     */
    private var project: Project?
    
    private let server: Server
    private let settingsManager: SettingsManager
    
    /**
     Инициализатор экрана
     
     - parameters:
        - settingsManager: экземпляр менеджера настроек
        - server: экземпляр сервера
        - possibleTaskToEdit: задача для редактирования, если значение = nil, то происходит создание новой задачи
        - project: проект, с которого был осуществлен переход на экран
     */
    init(settingsManager: SettingsManager, server: Server, possibleTaskToEdit: Task?, project: Project?) {
        self.settingsManager = settingsManager
        self.server = server
        self.possibleTaskToEdit = possibleTaskToEdit
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemRed
        view.addSubview(taskEditView)
        spinnerView.showSpinner(viewController: self)
        
        NSLayoutConstraint.activate([
            taskEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            taskEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            taskEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let taskToEdit = possibleTaskToEdit {
            title = "Редактирование задачи"
            taskBindModel.task = taskToEdit
        } else {
            let numbersOfDays = getNumberOfDaysBetweenDates()
            taskBindModel.daysBetweenDates = numbersOfDays
            title = "Добавление задачи"
        }
        
        if let project {
            taskBindModel.project = project
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
    
    /**
     Метод получает список проектов с сервера и привязывает к модели данных задачи,
     которая будет используется в TaskEditView
     
     - parameters:
        - completion: блок, который будет выполняться после успешного выполнения метода
     */
    private func getProjects(_ completion: @escaping () -> Void) {
        server.getProjects({ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let projects):
                self.taskBindModel.listProjects = projects
                completion()
            case .failure(let error):
                self.handleError(error)
            }
        })
    }
    
    /**
     Метод получает списов сотрудников с сервера и привязывает к модели данных задачи,
     которая будет используется в TaskEditView
     
     - parameters:
        - completion: блок, который будет выполняться после успешного выполнения метода
     */
    private func getEmployees(_ completion: @escaping () -> Void) {
        server.getEmployees({ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                self.taskBindModel.listEmployees = employees
                completion()
            case .failure(let error):
                self.handleError(error)
            }
        })
    }
    
    /**
     Метод для группового вызова методов получения проектов и сотрудников с сервера
     После происходит привязка значений для taskEditView
     */
    private func updateData() {
        let group = DispatchGroup()
        
        group.enter()
        getProjects {
            group.leave()
        }
        
        group.enter()
        getEmployees {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.taskEditView.bind(self.taskBindModel)
            self.spinnerView.hideSpinner()
        }
    }
    
    /**
     Метод получения значения количества дней по умолчанию между начальной и конечной датами в задаче из настроек приложения
     
     - returns:
        Максимальное количество дней для выполнения из настроек
     */
    private func getNumberOfDaysBetweenDates() -> Int {
        return settingsManager.getSettings().maxDays
    }
    
    /**
     Метод получает данные из текстФилдов экрана в виде модели задачи и передает ее дальше
     
     - returns:
     Модель задачи
     */
    private func unbind() throws -> TaskDetails {
        return try taskEditView.unbind()
    }
    
    /**
     Метод добавляет новую задачу в массив на сервере и возвращает на экран Список задач,
     в случае ошибки происходит ее обработка
     
     - parameters:
        - newTask: редактируемая модель задачи для добавления
     */
    private func addingNewTaskOnServer(_ newTask: TaskDetails) {
        self.spinnerView.showSpinner(viewController: self)
        server.addTask(taskDetails: newTask) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
            }
        }
    }
    
    /**
     Метод изменяет данные задачи на сервере, в случае ошибки происходит ее обработка
     
     - parameters:
        - editedTask: изменяемая задача
     */
    private func editingTaskOnServer(_ editedTask: Task) {
        self.spinnerView.showSpinner(viewController: self)
        server.editTask(id: editedTask.id, editedTask: editedTask) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
            }
        }
    }
    
    /**
     Метод, который получает собранные данные и сохраняет либо как новую, либо как отредактированную задачу,
     в случае ошибки происходит ее обработка
     */
    private func saveTask() throws {
        let bindedTask = try unbind()
        if let possibleTaskToEdit {
            let task = Task(name: bindedTask.name,
                            project: bindedTask.project,
                            employee: bindedTask.employee,
                            status: bindedTask.status,
                            requiredNumberOfHours: bindedTask.requiredNumberOfHours,
                            startDate: bindedTask.startDate,
                            endDate: bindedTask.endDate,
                            id: possibleTaskToEdit.id)
            editingTaskOnServer(task)
        } else {
            addingNewTaskOnServer(bindedTask)
        }
    }
    
    /**
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     - parameters:
        - error: обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let taskError = error as! BaseError
        ErrorAlert.showAlertController(message: taskError.message, viewController: self)
    }
    
    /**
     Target на кнопку Save - делает валидацию и вызывает метод saveTask,
     в случае ошибки происходит ее обработка
     */
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try saveTask()
        } catch {
            handleError(error)
        }
    }
    
    /**
     Target на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /**
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
