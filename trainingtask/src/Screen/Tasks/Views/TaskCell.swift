import UIKit

/*
 TaskCell - ячейка для tableView экрана Список задач
 */
class TaskCell: UITableViewCell {
    
    private let backgroundUIView = UIView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let projectLabel = UILabel(frame: .zero)
    private let taskLogoImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        backgroundUIView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundUIView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLogoImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundUIView.addSubview(nameLabel)
        backgroundUIView.addSubview(projectLabel)
        backgroundUIView.addSubview(taskLogoImage)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
            backgroundUIView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            backgroundUIView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor, constant: -50),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            projectLabel.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor, constant: 10),
            projectLabel.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
            projectLabel.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor, constant: -50),
            projectLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            taskLogoImage.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor, constant: -10),
            taskLogoImage.widthAnchor.constraint(equalToConstant: 40),
            taskLogoImage.heightAnchor.constraint(equalToConstant: 40),
            taskLogoImage.centerYAnchor.constraint(equalTo: backgroundUIView.centerYAnchor),
        ])
        
        backgroundUIView.backgroundColor = .clear
        taskLogoImage.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        projectLabel.alpha = 0.7
    }
    
    /*
     Метод присвоения значений для всех полей
     
     parameters:
     taskCellItem - модель данных для заполнения полей ячейки
     */
    func bind(_ taskCellItem: TaskCellItem) {
        nameLabel.text = taskCellItem.name
        projectLabel.text = taskCellItem.project
        
        var logoImage: UIImage? {
            switch taskCellItem.status {
            case .notStarted:
                return UIImage(named: "notStarted")
            case .inProgress:
                return UIImage(named: "inProgress")
            case .completed:
                return UIImage(named: "completed")
            case .postponed:
                return UIImage(named: "postponed")
            }
        }
        taskLogoImage.image = logoImage
    }
    
    /*
     Метод скрытия projectLabel, если переход на экран Список задач был осуществлен из проекта
     */
    func hideProjectLabel() {
        projectLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundUIView.backgroundColor =  .gray
            nameLabel.textColor = .white
            projectLabel.textColor = .white
        } else {
            backgroundUIView.backgroundColor =  .white
            nameLabel.textColor = .black
            projectLabel.textColor = .black
        }
    }
}
