import UIKit

/*
 EmployeeCell - ячейка для tableView экрана Список сотрудников
 */
class EmployeeCell: UITableViewCell {
    
    private let backgroundUIView = UIView(frame: .zero)
    private let surnameLabel = BorderedLabel(frame: .zero)
    private let nameLabel = BorderedLabel(frame: .zero)
    private let patronymicLabel = BorderedLabel(frame: .zero)
    private let positionLabel = BorderedLabel(frame: .zero)
    
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
        backgroundUIView.addSubview(surnameLabel)
        backgroundUIView.addSubview(nameLabel)
        backgroundUIView.addSubview(patronymicLabel)
        backgroundUIView.addSubview(positionLabel)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            backgroundUIView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            backgroundUIView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            surnameLabel.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor),
            surnameLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            surnameLabel.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
            surnameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            nameLabel.leadingAnchor.constraint(equalTo: surnameLabel.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            patronymicLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            patronymicLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            patronymicLabel.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
            patronymicLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            positionLabel.leadingAnchor.constraint(equalTo: patronymicLabel.trailingAnchor),
            positionLabel.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
            positionLabel.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
            positionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
        ])
        
        backgroundUIView.backgroundColor = .systemRed
    }
    
    /*
     Метод присвоения текста лейблам
     
     parameters:
     employee - модель сотрудника, содержащая данные для заполнения
     */
    func bind(_ employee: Employee) {
        surnameLabel.bind(employee.surname)
        nameLabel.bind(employee.name)
        patronymicLabel.bind(employee.patronymic)
        positionLabel.bind(employee.position)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundUIView.backgroundColor =  .gray
            surnameLabel.textColor = .white
            nameLabel.textColor = .white
            patronymicLabel.textColor = .white
            positionLabel.textColor = .white
        } else {
            backgroundUIView.backgroundColor =  .white
            surnameLabel.textColor = .black
            nameLabel.textColor = .black
            patronymicLabel.textColor = .black
            positionLabel.textColor = .black
        }
    }
}
