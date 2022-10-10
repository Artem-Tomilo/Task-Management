import UIKit

/*
 SettingsCustomView - кастомное View для отображения на экране Настройки
 */
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
    
    /*
     bind - метод для заполнения текущего view данными
     
     parametrs:
     labelText - данные для текста лейбла
     textFieldPlaceholder - данные для плейсхолдера textField
     textFieldText - данные для текста textField
     */
    func bind(labelText: String, textFieldPlaceholder: String, textFieldText: String) {
        label.text = labelText
        textField.placeholder = textFieldPlaceholder
        textField.text = textFieldText
    }

    /*
     unbind - метод для проверки и получения текста textField'а
     
     Возвращаемое значение - сам текст
     */
    func unbind() -> String {
        if let text = textField.text {
            return text
        }
        return "No data"
    }
    
    /*
     checkTextFieldForDelegate - метод для проверки текстфилда, если параметр flag == true, то в текстфилд можно вносить только цифры
     */
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
