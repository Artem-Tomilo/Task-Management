import UIKit

/**
 View для отображения и заполнения данных на экране настройки,
 предполагается для работы со строковыми значениями
 */
class SettingsInputView: UIView, UITextFieldDelegate {
    
    private let label = TitleLabel()
    private let textField: BorderedTextField
    
    /**
     Инициализация текущей view
     
     - parameters:
        - textField: отображаемый текстФилд
        - labelText: текст для отображения в лейбле
     */
    init(textField: BorderedTextField, labelText: String) {
        self.textField = textField
        self.label.bind(labelText)
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(textField)
        
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
        
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .systemRed
    }
    
    /**
     Метод для заполнения textField данными
     
     - parameters:
        - text: данные для заполнения textField
     */
    func bind(_ text: String) {
        textField.bind(text)
    }
    
    /**
     Метод возвращает текст textField
     
     - returns:
     Текст textField
     */
    func unbind() -> String {
        return textField.unbind()
    }
    
    /**
     Метод вызывается в том случае, если надо установить textField делегатом UITextFieldDelegate
     */
    func setTextFieldDelegate() {
        textField.delegate = self
    }
}
