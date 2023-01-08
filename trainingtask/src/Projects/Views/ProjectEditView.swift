import UIKit

/*
 ProjectEditView - view для отображения на экране Редактирование проекта
 */

class ProjectEditView: UIView, UITextFieldDelegate {
    
    private let nameTextField: BorderedTextField
    private let descriptionTextField: BorderedTextField
    
    override init(frame: CGRect) {
        self.nameTextField = BorderedTextField()
        self.descriptionTextField = BorderedTextField()
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameTextField)
        addSubview(descriptionTextField)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            descriptionTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameTextField.placeholder = "Название"
        descriptionTextField.placeholder = "Описание"
        
        nameTextField.becomeFirstResponder()
    }
    
    /*
     Метод для заполнения текущего view данными
     
     parametrs:
     nameTextFieldText - данные для текста nameTextField
     descriptionTextFieldText - данные для текста descriptionTextField
     */
    func bind(nameTextFieldText: String, descriptionTextFieldText: String) {
        nameTextField.text = nameTextFieldText
        descriptionTextField.text = descriptionTextFieldText
    }
    
    /*
     Метод для проверки и получения текста nameTextField
     
     Возвращаемое значение - текст nameTextField
     */
    func unbindProjectName() -> String {
        if let name = nameTextField.text {
            return name
        }
        return ""
    }
    
    /*
     Метод для проверки и получения текста descriptionTextField
     
     Возвращаемое значение - текст descriptionTextField
     */
    func unbindProjectDescription() -> String {
        if let description = descriptionTextField.text {
            return description
        }
        return ""
    }
    
    /*
     Target для кнопки done на клавиатуре - переходит на следующий textField, если он последний в списке, то прячет клавиатуру
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
            descriptionTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

