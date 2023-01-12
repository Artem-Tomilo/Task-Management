import UIKit

/*
 BorderedLabel - кастомный label
 */

class BorderedLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = .black
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.3
        numberOfLines = 0
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     Метод присвоения текста
     
     parameters:
     text - текст для label
     */
    func bindText(_ text: String) {
        self.text = text
    }
}
