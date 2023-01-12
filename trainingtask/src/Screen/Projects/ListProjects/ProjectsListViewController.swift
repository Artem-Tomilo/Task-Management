import UIKit

/*
 ProjectsListViewController - экран Список проектов, отображает tableView со всеми проектами, хранящимися на сервере
 */

class ProjectsListViewController: UIViewController, ProjectEditViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var spinnerView = SpinnerView()
    private static let projectCellIdentifier = "NewCell"
    private var projectsArray: [Project] = []
    private let errorAlertController = ErrorAlert()
    
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
        self.title = "Проекты"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProjectCell.self, forCellReuseIdentifier: ProjectsListViewController.projectCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let addNewProjectButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToEditProjectViewController(_:)))
        navigationItem.rightBarButtonItem = addNewProjectButton
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
    }
    
    /*
     Метод привязки значений в ячейку данными проекта
     
     parameters:
     cell - ячейка, в которой отображается проект
     project - проект, хранящийся в этой ячейке, данными которого она будет заполняться
     */
    private func settingCellText(for cell: UITableViewCell, with project: Project) {
        if let cell = cell as? ProjectCell {
            cell.bindText(nameText: project.name, descriptionText: project.description)
        }
    }
    
    /*
     Метод получение значения максимального количества записей из настроек приложения
     */
    private func getMaxRecordsCountFromSettings() -> Int {
        return settingsManager.getSettings().maxRecords
    }
    
    /*
     Метод загрузки данных - происходит запуск спиннера и вызов метода делегата: в completion блоке вызывается метод привязки данных и скрытие спиннера
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        serverDelegate.getProjects() { [weak self] projects in
            guard let self else { return }
            if self.getMaxRecordsCountFromSettings() != 0 {
                self.bind(Array(projects.prefix(self.getMaxRecordsCountFromSettings())))
            } else {
                self.bind(projects)
            }
            self.spinnerView.hideSpinner(from: self)
        } error: { [weak self] error in
            guard let self else { return }
            self.handleError(error)
        }
    }
    
    /*
     Метод привязки данных - приходящие данные с сервера сохраняются в массив и происходит обновление таблицы
     
     parameters:
     projects - приходящий массив данных с сервера
     */
    private func bind(_ projects: [Project]) {
        projectsArray = projects
        self.tableView.reloadData()
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsListViewController.projectCellIdentifier, for: indexPath) as? ProjectCell else { return UITableViewCell() }
        let project = projectsArray[indexPath.row]
        cell.bindText(nameText: project.name, descriptionText: project.description)
        settingCellText(for: cell, with: project)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projectsArray[indexPath.row]
        showTaskViewController(project)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     Удаление и редактирование проекта происходит после свайпа влево, в случае ошибки происходит ее обработка
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let project = try self.getProject(indexPath)
                self.showDeleteProjectAlert(project)
            } catch {
                self.handleError(error)
            }
        })
        
        let editCell = UIContextualAction(style: .normal, title: "Изменить", handler: { [weak self] _, _, close in
            guard let self = self else { return }
            do {
                let project = try self.getProject(indexPath)
                self.showEditProjectAlert(project)
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
     Метод получения текущего проекта, в случае ошибки происходит ее обработка
     
     parameters:
     indexPath проекта
     Возвращаемое значение - проект
     */
    private func getProject(_ indexPath: IndexPath) throws -> Project {
        if projectsArray.count > indexPath.row {
            return projectsArray[indexPath.row]
        }
        else {
            throw BaseError(message: "Не удалось получить проект")
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let projectError = error as! BaseError
        errorAlertController.showAlertController(message: projectError.message, viewController: self)
    }
    
    /*
     Метод вызова алерта для редактирования проекта и перехода на экран Редактирование проекта
     
     parameters:
     project - передаваемый проект для редактирования
     */
    private func showEditProjectAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите изменить этот проект?", message: "", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.showEditProjectViewController(project)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод вызова алерта для удаления проекта и последующего вызова метода удаления проекта
     
     parameters:
     project - передаваемый проект для удаления
     */
    private func showDeleteProjectAlert(_ project: Project) {
        let alert = UIAlertController(title: "Хотите удалить этот проект?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.deleteProject(project: project)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /*
     Метод удаления проекта - вызывает метод делагата для удаления проекта с сервера, после обновляет данные на главном потоке, в случае ошибки происходит ее обработка
     
     parameters:
     project - проект для удаления
     */
    private func deleteProject(project: Project) {
        serverDelegate.deleteProject(id: project.id) { result in
            switch result {
            case .success():
                self.loadData()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    /*
     Метод перехода на экран Редактирование проекта
     
     parameters:
     project - передаваемый проект для редактирования, если значение = nil, то будет создание нового проекта
     */
    private func showEditProjectViewController(_ project: Project?) {
        let viewController = ProjectEditViewController()
        if project != nil {
            viewController.possibleProjectToEdit = project
        }
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
     Метод перехода на экран Список задач, будут отображаться только те задачи, которые принадлежат данному проекту
     
     parameters:
     project - передаваемый проект для отображения его задач
     */
    private func showTaskViewController(_ project: Project) {
        let viewController = TasksListViewController(settingsManager: settingsManager, serverDelegate: serverDelegate)
        viewController.project = project
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
     Target на кнопку добавления нового проекта:
     переходит на экран Редактирование проекта
     */
    @objc func moveToEditProjectViewController(_ sender: UIBarButtonItem) {
        showEditProjectViewController(nil)
    }
    
    /*
     Target на обновление таблицы через UIRefreshControl
     */
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    /*
     Метод протокола ProjectEditViewControllerDelegate, который возвращает на экран Список проектов после нажатия кнопки Cancel
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     */
    func addProjectDidCancel(_ controller: ProjectEditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Метод протокола ProjectEditViewControllerDelegate, который добавляет новый проект в массив на сервере и возвращает на экран Список проектов, в случае ошибки происходит ее обработка
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     newProject - новый проект для добавления
     */
    func addNewProject(_ controller: ProjectEditViewController, newProject: Project) {
        self.navigationController?.popViewController(animated: true)
        serverDelegate.addProject(project: newProject) { result in
            switch result {
            case .success():
                self.loadData()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    /*
     Метод протокола ProjectEditViewControllerDelegate, который изменяет данные проекта, в случае ошибки происходит ее обработка
     
     parameters:
     controller - ViewController, на котором вызывается данный метод
     editedProject - изменяемый проект
     */
    func editProject(_ controller: ProjectEditViewController, editedProject: Project) {
        self.navigationController?.popViewController(animated: true)
        serverDelegate.editProject(id: editedProject.id, editedProject: editedProject) { result in
            switch result {
            case .success():
                self.loadData()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
}
