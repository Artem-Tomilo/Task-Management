import UIKit

/**
 Экран Главное меню, отображает tableView с возможными вариантами перехода на другие экраны
 */
class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private static let cellIdentifier = "Cell"
    private let settingsManager: SettingsManager
    private let server: Server
    
    /**
     Инициализатор экрана
     
     - parameters:
        - settingsManager: экремпляр менеджера настроек для передачи на следующий экран
        - server: экземпляр сервера для передачи на следующий экран
     */
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
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCustomCell.self, forCellReuseIdentifier: MainMenuViewController.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.backgroundColor = .white
        tableView.backgroundColor = .systemRed
    }
    
    /**
     Метод получения списка меню в строковом варианте
     
     - parameters:
        - list: список элементов меню
     
     - returns:
        Cтроковый вариант списка
     */
    private func getMenuListTitleFrom(_ list: MainMenuList) -> String {
        switch list {
        case .projects:
            return "Проекты"
        case .tasks:
            return "Задачи"
        case .employees:
            return "Сотрудники"
        case .settings:
            return "Настройки"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainMenuList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMenuViewController.cellIdentifier,
                                                       for: indexPath) as? MenuCustomCell else { return UITableViewCell() }
        cell.bind(getMenuListTitleFrom(MainMenuList.allCases[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let projectsListViewController = ProjectsListViewController(settingsManager: settingsManager,
                                                                        server: server)
            navigationController?.pushViewController(projectsListViewController, animated: true)
        case 1:
            let tasksListViewController = TasksListViewController(settingsManager: settingsManager,
                                                                  server: server, project: nil)
            navigationController?.pushViewController(tasksListViewController, animated: true)
        case 2:
            let employeesListController = EmployeesListController(settingsManager: settingsManager,
                                                                  server: server)
            navigationController?.pushViewController(employeesListController, animated: true)
        case 3:
            let settingsViewController = SettingsViewController(settingsManager: settingsManager)
            navigationController?.pushViewController(settingsViewController, animated: true)
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
