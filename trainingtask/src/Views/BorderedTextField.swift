import UIKit

/*
 BorderedTextField - кастомный TextField
 */

class BorderedTextField: UITextField {
    
    init(frame: CGRect, placeholder: String) {
        super.init(frame: frame)
        self.placeholder = placeholder
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
    
    func bindText(_ text: String) {
        self.text = text
    }
    
    func unbindText() -> String {
        if let text {
            return text
        }
        return ""
    }
}
