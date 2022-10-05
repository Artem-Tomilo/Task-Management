import UIKit

class SplashViewController: UIViewController {
    
    private var nameLabel = UILabel()
    private var versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let delay = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let vc = MainMenuViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setup() {
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
        nameLabel.attributedText = NSAttributedString(string: name.capitalized, attributes: [.font: UIFont.systemFont(ofSize: 25)])
        nameLabel.textAlignment = .center
        
        versionLabel.attributedText = NSAttributedString(string: "Version: \(version)", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        versionLabel.textAlignment = .center
    }
}
