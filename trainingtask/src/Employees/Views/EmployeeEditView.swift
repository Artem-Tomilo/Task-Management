import UIKit

/*
 EmployeeEditView - view для отображения на экране Редактирование сотрудника
 */
class EmployeeEditView: UIView, UITextFieldDelegate {
    
    private let surnameTextField: BorderedTextField
    private let nameTextField: BorderedTextField
    private let patronymicTextField: BorderedTextField
    private let positionTextField: BorderedTextField
    
    override init(frame: CGRect) {
        self.surnameTextField = BorderedTextField()
        self.nameTextField = BorderedTextField()
        self.patronymicTextField = BorderedTextField()
        self.positionTextField = BorderedTextField()
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(surnameTextField)
        addSubview(nameTextField)
        addSubview(patronymicTextField)
        addSubview(positionTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            surnameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            surnameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            patronymicTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            patronymicTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            patronymicTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            positionTextField.topAnchor.constraint(equalTo: patronymicTextField.bottomAnchor, constant: 50),
            positionTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            positionTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        surnameTextField.delegate = self
        nameTextField.delegate = self
        patronymicTextField.delegate = self
        positionTextField.delegate = self
        
        surnameTextField.placeholder = "Фамилия"
        nameTextField.placeholder = "Имя"
        patronymicTextField.placeholder = "Отчество"
        positionTextField.placeholder = "Должность"
        
        surnameTextField.becomeFirstResponder()
    }
    
    /*
     bind - метод для заполнения текущего view данными
     
     parametrs:
     surnameTextFieldText - данные для текста surnameTextField
     nameTextFieldText - данные для текста nameTextField
     patronymicTextFieldText - данные для текста patronymicTextField
     positionTextFieldText - данные для текста positionTextField
     */
    func bind(surnameTextFieldText: String, nameTextFieldText: String, patronymicTextFieldText: String, positionTextFieldText: String) {
        surnameTextField.text = surnameTextFieldText
        nameTextField.text = nameTextFieldText
        patronymicTextField.text = patronymicTextFieldText
        positionTextField.text = positionTextFieldText
    }
    
    /*
     unbind - метод для проверки и получения текста textField'ов
     
     Возвращаемые значения - текста всех textField'ов
     */
    func unbind() -> (String, String, String, String) {
        if let surname = surnameTextField.text,
           let name = nameTextField.text,
           let patronymic = patronymicTextField.text,
           let position = positionTextField.text {
            return (surname, name, patronymic, position)
        }
        return ("No data", "No data", "No data", "No data")
    }
    
    /*
     таргет для кнопки done на клавиатуре - переходит на следующий textField, если он последний в списке, то прячет клавиатуру
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case surnameTextField:
            nameTextField.becomeFirstResponder()
        case nameTextField:
            patronymicTextField.becomeFirstResponder()
        case patronymicTextField:
            positionTextField.becomeFirstResponder()
        case positionTextField:
            positionTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
