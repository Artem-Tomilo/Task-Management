import UIKit

class MenuCustomCell: UITableViewCell {
    private let label = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = ""
    }
    
    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20.0),
            label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -20.0),
        ])
        backgroundColor = .systemRed
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? .lightText : .systemRed
        label.textColor = selected ? .black : .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        backgroundColor = highlighted ? .lightText : .systemRed
        label.textColor = highlighted ? .black : .white
    }
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
}
