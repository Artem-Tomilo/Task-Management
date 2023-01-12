import UIKit

/*
 EmployeeEditView - view для отображения на экране Редактирование сотрудника
 */

class EmployeeEditView: UIView, UITextFieldDelegate {
    
    private let surnameTextField = BorderedTextField(frame: .zero, placeholder: "Фамилия")
    private let nameTextField = BorderedTextField(frame: .zero, placeholder: "Имя")
    private let patronymicTextField = BorderedTextField(frame: .zero, placeholder: "Отчество")
    private let positionTextField = BorderedTextField(frame: .zero, placeholder: "Должность")
    
    override init(frame: CGRect) {
        
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
    }
    
    /*
     Метод вызова FirstResponder при загрузке view
     */
    func initFirstResponder() {
        surnameTextField.becomeFirstResponder()
    }
    
    /*
     Метод для заполнения текущего view данными
     
     parametrs:
     surnameTextFieldText - данные для текста surnameTextField
     nameTextFieldText - данные для текста nameTextField
     patronymicTextFieldText - данные для текста patronymicTextField
     positionTextFieldText - данные для текста positionTextField
     */
    func bind(surnameTextFieldText: String, nameTextFieldText: String,
              patronymicTextFieldText: String, positionTextFieldText: String) {
        surnameTextField.bindText(surnameTextFieldText)
        nameTextField.bindText(nameTextFieldText)
        patronymicTextField.bindText(patronymicTextFieldText)
        positionTextField.bindText(positionTextFieldText)
    }
    
    /*
     Метод для проверки и получения текста surnameTextField
     
     Возвращаемое значение - текст surnameTextField
     */
    func unbindSurname() -> String {
        return surnameTextField.unbindText()
    }
    
    /*
     Метод для проверки и получения текста nameTextField
     
     Возвращаемое значение - текст nameTextField
     */
    func unbindName() -> String {
        return nameTextField.unbindText()
    }
    
    /*
     Метод для проверки и получения текста patronymicTextField
     
     Возвращаемое значение - текст patronymicTextField
     */
    func unbindPatronymic() -> String {
        return patronymicTextField.unbindText()
    }
    
    /*
     Метод для проверки и получения текста positionTextField
     
     Возвращаемое значение - текст positionTextField
     */
    func unbindPosition() -> String {
        return positionTextField.unbindText()
    }
    
    /*
     Target для кнопки done на клавиатуре - переходит на следующий textField, если он последний в списке, то прячет клавиатуру
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
