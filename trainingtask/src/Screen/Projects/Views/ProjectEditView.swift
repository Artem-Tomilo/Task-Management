import UIKit

/*
 ProjectEditView - view для отображения на экране Редактирование проекта
 */

class ProjectEditView: UIView, UITextFieldDelegate {
    
    private let nameTextField = BorderedTextField(placeholder: "Название")
    private let descriptionTextField = BorderedTextField(placeholder: "Описание")
    
    override init(frame: CGRect) {
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
    }
    
    /*
     Метод вызова FirstResponder при загрузке view
     */
    func initFirstResponder() {
        nameTextField.becomeFirstResponder()
    }
    
    /*
     Метод для заполнения текущего view данными
     
     parametrs:
     projectDetails - значения редактируемого проекта, собранные в виде модели редактируемых данных проекта
     */
    func bind(_ projectDetails: ProjectDetails) {
        nameTextField.bind(projectDetails.title)
        descriptionTextField.bind(projectDetails.description)
    }
    
    /*
     Метод для проверки и получения данных из текстФилдов экрана,
     после проверки данные собираются в модель редактируемых данных проекта и отправляются на экран Список проектов
     Возвращаемое значение - модель редактируемых данных
     */
    func unbind() throws -> ProjectDetails {
        let title = try Validator.validateTextForMissingValue(text: nameTextField.unbind(),
                                                              message: "Введите название")
        let description = try Validator.validateTextForMissingValue(text: descriptionTextField.unbind(),
                                                                    message: "Введите описание")
        let projectDetails = ProjectDetails(title: title, description: description)
        return projectDetails
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

