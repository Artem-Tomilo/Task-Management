import UIKit

/*
 TasksListViewController - экран Список задач, отображает tableView со всеми задачами, хранящимися на сервере
 */
class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let spinnerView = SpinnerView()
    private static let taskCellIdentifier = "TaskCell"
    private var tasksArray: [Task] = []
    
    /*
     Если свойство имеет значение, то будут отображаться задачи, принадлежащие этому проекту,
     если свойство равно nil, будут отображаться все задачи
     */
    private var project: Project?
    private let server: Server
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager, server: Server, project: Project?) {
        self.settingsManager = settingsManager
        self.server = server
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func configureUI() {
        navigationController?.isNavigationBarHidden = false
        self.title = "Задачи"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TasksListViewController.taskCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let addNewTaskButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(moveToEditTaskViewController(_:)))
        navigationItem.rightBarButtonItem = addNewTaskButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     Метод получения значения максимального количества записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        return settingsManager.getSettings().maxRecords
    }
    
    /*
     Метод загрузки данных - происходит запуск спиннера и проверка проекта на значение,
     если значение есть - вызов метода сервера на получение задач для этого проекта,
     если значения нет, вызов метода для получения всех задач,
     в completion блоке вызывается метод привязки данных согласно количеству записей из настроек и скрытие спиннера,
     в случае возникновения ошибки происходит ее обработка
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        if let project {
            server.getTasksFor(project: project) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let tasks):
                    self.bindTasksAccordingRecordsCounts(tasks)
                    self.spinnerView.hideSpinner()
                case .failure(let error):
                    self.spinnerView.hideSpinner()
                    self.handleError(error)
                }
            }
        } else {
            server.getTasks { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let tasks):
                    self.bindTasksAccordingRecordsCounts(tasks)
                    self.spinnerView.hideSpinner()
                case .failure(let error):
                    self.spinnerView.hideSpinner()
                    self.handleError(error)
                }
            }
        }
    }
    
    /*
     Метод привязки данных - приходящие данные с сервера сохраняются в массив и происходит обновление таблицы
     
     parameters:
     tasks - приходящий массив данных с сервера
     */
    private func bind(_ tasks: [Task]) {
        tasksArray = tasks
        self.tableView.reloadData()
    }
    
    /*
     Метод проверки значения максимального количества записей из настроек,
     если значение не равно 0, происходит запись данных согласно значению, если равно 0 - запись всех задач
     
     parameters:
     tasks - приходящий массив данных с сервера
     */
    private func bindTasksAccordingRecordsCounts(_ tasks: [Task]) {
        if self.getMaxRecordsCountFromSettings() != 0 {
            self.bind(Array(tasks.prefix(self.getMaxRecordsCountFromSettings())))
        } else {
            self.bind(tasks)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksListViewController.taskCellIdentifier,
                                                       for: indexPath) as? TaskCell else { return UITableViewCell() }
        if project != nil {
            cell.hideProjectLabel()
        }
        let task = tasksArray[indexPath.row]
        let taskCellItem = TaskCellItem(name: task.name, project: task.project.name, status: task.status)
        cell.bind(taskCellItem)
        return cell
    }
    
    /*
     Удаление и редактирование задачи происходит после свайпа влево, в случае ошибки происходит ее обработка
     */
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let task = try self.getTask(indexPath)
                self.showDeleteTaskAlert(task)
            } catch {
                self.handleError(error)
            }
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let task = try self.getTask(indexPath)
                self.showEditTaskAlert(task)
            } catch {
                self.handleError(error)
            }
        })
        return UISwipeActionsConfiguration(actions: [
            deleteCell,
            editCell
        ])
    }
    
    /*
     Метод получения текущей задачи, в случае ошибки происходит ее обработка
     
     parameters:
     indexPath задачи
     Возвращаемое значение - задача
     */
    private func getTask(_ indexPath: IndexPath) throws -> Task {
        if tasksArray.count > indexPath.row {
            return tasksArray[indexPath.row]
        }
        else {
            throw BaseError(message: "Не удалось получить задачу")
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let taskError = error as! BaseError
        ErrorAlert.showAlertController(message: taskError.message, viewController: self)
    }
    
    /*
     Метод вызова алерта для редактирования задачи и перехода на экран Редактирование задачи
     
     parameters:
     task - передаваемая задача для редактирования
     */
    private func showEditTaskAlert(_ task: Task) {
        let alert = UIAlertController(title: "Хотите изменить эту задачу?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.showEditTaskViewController(task)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод вызова алерта для удаления задачи и последующего вызова метода удаления задачи
     
     parameters:
     task - передаваемый задача для удаления
     */
    private func showDeleteTaskAlert(_ task: Task) {
        let alert = UIAlertController(title: "Хотите удалить эту задачу?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.deleteTask(task: task)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод удаления задачи - вызывает метод делагата для удаления задачи с сервера,
     после обновляет данные на главном потоке, в случае ошибки происходит ее обработка
     
     parameters:
     task - задача для удаления
     */
    private func deleteTask(task: Task) {
        server.deleteTask(id: task.id) { result in
            switch result {
            case .success():
                self.loadData()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    /*
     Метод перехода на экран Редактирование задачи
     
     parameters:
     task - передаваемая задача для редактирования, если значение = nil, то будет создание новой задачи
     */
    private func showEditTaskViewController(_ task: Task?) {
        var project: Project?
        var possibleTaskToEdit: Task?
        
        if self.project != nil {
            project = self.project
        }
        if task != nil {
            possibleTaskToEdit = task
        }
        let viewController = TaskEditViewController(settingsManager: settingsManager, server: server,
                                                    possibleTaskToEdit: possibleTaskToEdit, project: project)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
     Target на кнопку добавления новой задачи:
     переходит на экран Редактирование задачи
     */
    @objc func moveToEditTaskViewController(_ sender: UIBarButtonItem) {
        showEditTaskViewController(nil)
    }
    
    /*
     Target на обновление таблицы через UIRefreshControl
     */
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
}
