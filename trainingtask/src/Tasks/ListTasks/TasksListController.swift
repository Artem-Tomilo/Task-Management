import UIKit

/*
 TasksListViewController - экран Список задач, отображает tableView со всеми задачами, хранящимися на сервере
 */

class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskEditViewControllerDelegate {
    
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let taskCellIdentifier = "TaskCell"
    private var tasksArray: [Task] = []
    private let alertController = Alert()
    
    var project: Project? // если свойство имеет значение, то будут отображаться задачи, принадлежащие этому проекту, если свойство равно nil, будут отображаться все задачи
    
    private var serverDelegate: Server
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
        loadData()
    }
    
    private func setup() {
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
        
        let addNewTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToEditTaskViewController(_:)))
        navigationItem.rightBarButtonItem = addNewTaskButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     Метод привязки значений в ячейку данными задачи
     
     parameters:
     cell - ячейка, в которой отображается задача
     task - задача, хранящийся в этой ячейке, данными которой она будет заполняться
     */
    private func settingCellText(for cell: UITableViewCell, with task: Task) {
        if let cell = cell as? TaskCell {
            cell.bindText(nameText: task.name, projectText: task.project.name)
        }
    }
    
    /*
     Метод получение значения максимального количества записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        guard let count = try? settingsManager.getSettings().maxRecords else { return 0 }
        return count
    }
    
    /*
     Метод загрузки данных - происходит запуск спиннера и проверка проекта на значение, если значение есть - вызов метода делегата на получение задач для этого проекта, если значения нет, вызов метода для получения всех задач, в completion блоке вызывается метод привязки данных и скрытие спиннера, в случае возникновения ошибки происходит ее обработка
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        do {
            if let project {
                try serverDelegate.getTasksFor(project: project) { [weak self] tasks in
                    guard let self else { return }
                    self.bindTasksAccordingRecordsCounts(tasks)
                    self.spinnerView.hideSpinner(from: self)
                }
            } else {
                serverDelegate.getTasks() { [weak self] tasks in
                    guard let self else { return }
                    self.bindTasksAccordingRecordsCounts(tasks)
                    self.spinnerView.hideSpinner(from: self)
                }
            }
        } catch {
            self.spinnerView.hideSpinner(from: self)
            handleError(error)
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
     Метод проверки значения максимального количества записей из настроек, если значение не равно 0, происходит запись данных согласно значению, если равно 0, запись всех задач
     
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksListViewController.taskCellIdentifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        if project != nil {
            cell.hideProjectLabel()
        }
        let task = tasksArray[indexPath.row]
        cell.bindText(nameText: task.name, projectText: task.project.name)
        cell.changeImage(status: task.status)
        settingCellText(for: cell, with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    /*
     Удаление и редактирование задачи происходит после свайпа влево, в случае ошибки происходит ее обработка
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
     Метод получения текущей задачи
     
     parameters:
     indexPath задачи
     Возвращаемое значение - задача
     */
    private func getTask(_ indexPath: IndexPath) throws -> Task {
        if tasksArray.count > indexPath.row {
            return tasksArray[indexPath.row]
        }
        else {
            throw TaskStubErrors.noSuchTask
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let taskError = error as! TaskStubErrors
        alertController.showAlertController(message: taskError.message, viewController: self)
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
     Метод удаления задачи - вызывает метод делагата для удаления задачи с сервера, после обновляет данные на главном потоке, в случае ошибки происходит ее обработка
     
     parameters:
     task - задача для удаления
     */
    private func deleteTask(task: Task) {
        do {
            try serverDelegate.deleteTask(id: task.id) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод перехода на экран Редактирование задачи
     
     parameters:
     task - передаваемая задача для редактирования, если значение = nil, то будет создание новой задачи
     */
    private func showEditTaskViewController(_ task: Task?) {
        let viewController = TaskEditViewController(settingsManager: settingsManager, serverDelegate: serverDelegate)
        if project != nil {
            viewController.project = project
        }
        if task != nil {
            viewController.possibleTaskToEdit = task
        }
        viewController.delegate = self
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
    
    /*
     Метод протокола TaskEditViewControllerDelegate, который возвращает на экран Список задач после нажатия кнопки Cancel
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     */
    func addTaskDidCancel(_ controller: TaskEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Метод протокола TaskEditViewControllerDelegate, который добавляет новую задачу в массив на сервере и возвращает на экран Список задач, в случае ошибки происходит ее обработка
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     newTask - новая задача для добавления
     */
    func addNewTask(_ controller: TaskEditViewController, newTask: Task) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.addTask(task: newTask) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод протокола TaskEditViewControllerDelegate, который изменяет данные задачи, в случае ошибки происходит ее обработка
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     editedTask - изменяемая задача
     */
    func editTask(_ controller: TaskEditViewController, editedTask: Task) {
        do {
            self.navigationController?.popViewController(animated: true)
            try serverDelegate.editTask(id: editedTask.id, editedTask: editedTask) {
                self.loadData()
            }
        } catch {
            handleError(error)
        }
    }
}
