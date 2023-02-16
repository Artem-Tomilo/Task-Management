import UIKit

/*
 ProjectsListViewController - экран Список проектов, отображает tableView со всеми проектами, хранящимися на сервере
 */
class ProjectsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let spinnerView = SpinnerView()
    private static let projectCellIdentifier = "NewCell"
    private var projectsArray: [Project] = []
    
    private let server: Server
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager, server: Server) {
        self.settingsManager = settingsManager
        self.server = server
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
        
        let addNewProjectButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(moveToEditProjectViewController(_:)))
        navigationItem.rightBarButtonItem = addNewProjectButton
        
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
     Метод загрузки данных - происходит запуск спиннера и вызов метода сервера:
     в completion блоке вызывается метод привязки данных согласно количеству записей из настроек и скрытие спиннера,
     в случае ошибки происходит ее обработка
     */
    private func loadData() {
        spinnerView.showSpinner(viewController: self)
        server.getProjects() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let projects):
                if self.getMaxRecordsCountFromSettings() != 0 {
                    self.bind(Array(projects.prefix(self.getMaxRecordsCountFromSettings())))
                } else {
                    self.bind(projects)
                }
                self.spinnerView.hideSpinner()
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
            }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsListViewController.projectCellIdentifier,
                                                       for: indexPath) as? ProjectCell else { return UITableViewCell() }
        let project = projectsArray[indexPath.row]
        cell.bind(project)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projectsArray[indexPath.row]
        showTaskViewController(project)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     Удаление и редактирование проекта происходит после свайпа влево, в случае ошибки происходит ее обработка
     */
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
        ErrorAlert.showAlertController(message: projectError.message, viewController: self)
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
     Метод удаления проекта - вызывает метод делагата для удаления проекта с сервера,
     после обновляет данные на главном потоке, в случае ошибки происходит ее обработка
     
     parameters:
     project - проект для удаления
     */
    private func deleteProject(project: Project) {
        server.deleteProject(id: project.id) { result in
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
        if let project {
            let viewController = ProjectEditViewController(server: server, possibleProjectToEdit: project)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = ProjectEditViewController(server: server, possibleProjectToEdit: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    /*
     Метод перехода на экран Список задач, будут отображаться только те задачи, которые принадлежат данному проекту
     
     parameters:
     project - передаваемый проект для отображения его задач
     */
    private func showTaskViewController(_ project: Project) {
        let viewController = TasksListViewController(settingsManager: settingsManager, server: server, project: project)
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
}
