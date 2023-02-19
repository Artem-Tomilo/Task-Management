import UIKit

/**
 Ячейка для  экрана Список проектов
 */
class ProjectCell: UITableViewCell {
    
    private let backgroundUIView = UIView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        backgroundUIView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(backgroundUIView)
        backgroundUIView.addSubview(nameLabel)
        backgroundUIView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            backgroundUIView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            backgroundUIView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalTo: backgroundUIView.heightAnchor, multiplier: 0.5),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: backgroundUIView.heightAnchor, multiplier: 0.5)
        ])
        
        nameLabel.layer.borderWidth = 0
        descriptionLabel.layer.borderWidth = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        backgroundUIView.backgroundColor = .systemRed
    }
    
    /**
     Метод присвоения текста лейблам
     
     - parameters:
        - project: модель проекта, содержащая данные для заполнения
     */
    func bind(_ project: Project) {
        nameLabel.text = project.name
        descriptionLabel.text = project.description
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            backgroundUIView.backgroundColor =  .gray
            nameLabel.textColor = .white
            descriptionLabel.textColor = .white
        } else {
            backgroundUIView.backgroundColor =  .white
            nameLabel.textColor = .black
            descriptionLabel.textColor = .black
        }
    }
}
