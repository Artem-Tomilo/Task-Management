import UIKit

/*
 EmployeeEditViewController - экран Редактирование сотрудника, отображает необходимые поля для введения нового, либо редактирования существующего сотрудника
 */
class EmployeeEditViewController: UIViewController, UITextFieldDelegate {
    
    private let employeeEditView = EmployeeEditView()
    private var saveButton = UIBarButtonItem()
    private var cancelButton = UIBarButtonItem()
    
    weak var delegate: EmployeeEditViewControllerDelegate?
    
    var possibleEmployeeToEdit: Employee? // свойство, в которое будет записываться передаваемый сотрудник для редактирования
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(employeeEditView)
        
        NSLayoutConstraint.activate([
            employeeEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            employeeEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            employeeEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            employeeEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        if let employeeToEdit = possibleEmployeeToEdit {
            title = "Редактирование сотрудника"
            employeeEditView.bind(surnameTextFieldText: employeeToEdit.surname, nameTextFieldText: employeeToEdit.name, patronymicTextFieldText: employeeToEdit.patronymic, positionTextFieldText: employeeToEdit.position)
        } else {
            title = "Добавление сотрудника"
        }
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     saveEmployee - метод, который проверяет и сохраняет либо нового, либо отредактированного сотрудника
     */
    private func saveEmployee() {
        if let editedEmployee = possibleEmployeeToEdit {
            editingEmployee(editedEmployee: editedEmployee)
        } else {
            createNewEmployee()
        }
    }
    
    /*
     editingEmployee - метод, который привязывает новые данные для редактируемого сотрудника
     
     parameters:
     editedEmployee - редактируемый сотрудник
     */
    private func editingEmployee(editedEmployee: Employee) {
        let (surname, name, patronymic, position) = employeeEditView.unbind()
        var employee = editedEmployee
        employee.surname = surname
        employee.name = name
        employee.patronymic = patronymic
        employee.position = position
        delegate?.editEmployee(self, editedEmployee: employee)
    }
    
    /*
     createNewEmployee - метод, который создает нового сотрудника
     */
    private func createNewEmployee() {
        let (surname, name, patronymic, position) = employeeEditView.unbind()
        let newEmployee = Employee(surname: surname, name: name, patronymic: patronymic, position: position, id: delegate?.idCounter ?? 0)
        delegate?.addNewEmployee(self, newEmployee: newEmployee)
    }
    
    /*
     saveEmployeeButtonTapped - таргет на кнопку Save:
     вызывает метод saveEmployee()
     */
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        saveEmployee()
    }
    
    /*
     таргет на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.addEmployeeDidCancel(self)
    }
    
    /*
     таргет для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
