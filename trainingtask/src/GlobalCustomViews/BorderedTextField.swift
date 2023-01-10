import UIKit

/*
 BorderedTextField - кастомный TextField
 */

class BorderedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        borderStyle = .roundedRect
        returnKeyType = .done
        enablesReturnKeyAutomatically = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bindText(text: String) {
        self.text = text
    }
    
    func unbindText() -> String {
        if let text {
            return text
        }
        return ""
    }
    
    func bindPlaceholder(text: String) {
        self.placeholder = text
    }
}
