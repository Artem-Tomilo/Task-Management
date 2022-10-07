import UIKit

class SettingsCustomView: UIView, UITextViewDelegate, UITextFieldDelegate {
    private let label: SettingsLabel
    private let textField: CustomTextField
    
    override init(frame: CGRect) {
        self.label = SettingsLabel()
        self.textField = CustomTextField()
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        addSubview(textField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addLabelText(text: String) {
        label.text = text
    }
    
    func addTextFieldPlaceholder(text: String) {
        textField.placeholder = text
    }
    
    func setTextFieldText(text: String) {
        textField.text = text
    }
    
    func getTextFieldText() -> String {
        if let text = textField.text {
            return text
        }
        return "No data"
    }
    
    func checkTextFieldForDelegate(flag: Bool) {
        if flag {
            textField.delegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.allSatisfy {
            $0.isNumber
        }
    }
}
