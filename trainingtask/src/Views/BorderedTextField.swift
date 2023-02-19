import UIKit

/**
 TextField с предустановленными значениями для использования на разных экранах
 */
class BorderedTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
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
    
    /**
     Метод присвоения текста
     
     - parameters:
        - text: текст для textField
     */
    func bind(_ text: String) {
        self.text = text
    }
    
    /**
     Метод получения текста textField, в случает отсутствия текста будет возвращена пустая строка
     
     - returns:
     Текст textField
     */
    func unbind() -> String {
        if let text {
            return text
        }
        return ""
    }
}
