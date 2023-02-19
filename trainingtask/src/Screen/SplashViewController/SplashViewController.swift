import UIKit

/**
 Начальный экран, который держится 5 секунд и осуществляет переход на экран Главное меню
 */
class SplashViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let versionLabel = UILabel()
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
        
        let delay = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let viewController = MainMenuViewController(settingsManager: self.settingsManager, server: self.server)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(versionLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            versionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        guard let name = name,
              let version = version else { return }
        nameLabel.attributedText = NSAttributedString(string: name.capitalized,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 25)])
        nameLabel.textAlignment = .center
        
        versionLabel.attributedText = NSAttributedString(string: "Version: \(version)",
                                                         attributes: [.font: UIFont.systemFont(ofSize: 20)])
        versionLabel.textAlignment = .center
    }
}
