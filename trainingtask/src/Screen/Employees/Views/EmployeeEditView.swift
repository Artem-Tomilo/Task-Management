import UIKit

/*
 EmployeeEditView - view для отображения на экране Редактирование сотрудника
 */
class EmployeeEditView: UIView, UITextFieldDelegate {
    
    private let surnameTextField = BorderedTextField(placeholder: "Фамилия")
    private let nameTextField = BorderedTextField(placeholder: "Имя")
    private let patronymicTextField = BorderedTextField(placeholder: "Отчество")
    private let positionTextField = BorderedTextField(placeholder: "Должность")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
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
     Метод для заполнения текущего view данными
     
     parametrs:
     employeeDetails - значения редактируемого сотрудника, собранные в виде модели редактируемых данных
     */
    func bind(_ employeeDetails: EmployeeDetails) {
        surnameTextField.bind(employeeDetails.surname)
        nameTextField.bind(employeeDetails.name)
        patronymicTextField.bind(employeeDetails.patronymic)
        positionTextField.bind(employeeDetails.position)
    }
    
    /*
     Метод для проверки и получения данных из текстФилдов экрана,
     после проверки данные собираются в модель редактируемых данных сотрудника и отправляются на экран Список сотрудников
     
     Возвращаемое значение - модель редактируемых данных сотрудника
     */
    func unbind() throws -> EmployeeDetails {
        let surname = try Validator.validateTextForMissingValue(text: surnameTextField.unbind(),
                                                                message: "Введите фамилию")
        let name = try Validator.validateTextForMissingValue(text: nameTextField.unbind(),
                                                             message: "Введите имя")
        let patronymic = try Validator.validateTextForMissingValue(text: patronymicTextField.unbind(),
                                                                   message: "Введите отчество")
        let position = try Validator.validateTextForMissingValue(text: positionTextField.unbind(),
                                                                 message: "Введите должность")
        let employeeDetails = EmployeeDetails(surname: surname,
                                              name: name,
                                              patronymic: patronymic,
                                              position: position)
        return employeeDetails
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
