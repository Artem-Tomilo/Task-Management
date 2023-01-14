import UIKit

/*
 EmployeeEditViewController - экран Редактирование сотрудника, отображает необходимые поля для введения нового, либо редактирования существующего сотрудника
 */

class EmployeeEditViewController: UIViewController, UITextFieldDelegate {
    
    private let employeeEditView = EmployeeEditView()
    private let spinnerView = SpinnerView()
    
    var possibleEmployeeToEdit: Employee? // свойство, в которое будет записываться передаваемый сотрудник для редактирования
    private let serverDelegate: Server // делегат, вызывающий методы обработки сотрудников на сервере
    
    init(serverDelegate: Server) {
        self.serverDelegate = serverDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        employeeEditView.initFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(employeeEditView)
        
        NSLayoutConstraint.activate([
            employeeEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            employeeEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            employeeEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            employeeEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let employeeToEdit = possibleEmployeeToEdit {
            title = "Редактирование сотрудника"
            employeeEditView.bind(surnameTextFieldText: employeeToEdit.surname,
                                  nameTextFieldText: employeeToEdit.name,
                                  patronymicTextFieldText: employeeToEdit.patronymic,
                                  positionTextFieldText: employeeToEdit.position)
        } else {
            title = "Добавление сотрудника"
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод получает данные из текстФилдов экрана, делает валидацию и собирает модель сотрудника,
     при редактировании заменяет данные редактирумого сотрудника новыми данными
     
     Возвращаемое значение - сотрудник
     */
    private func unbind() throws -> Employee {
        let surname = try employeeEditView.unbindSurname()
        let name = try employeeEditView.unbindName()
        let patronymic = try employeeEditView.unbindPatronymic()
        let position = try employeeEditView.unbindPosition()
        
        var employee = Employee(surname: surname, name: name, patronymic: patronymic, position: position)
        
        if let possibleEmployeeToEdit {
            employee.id = possibleEmployeeToEdit.id
        }
        return employee
    }
    
    /*
     Метод добавляет нового сотрудника в массив на сервере и возвращает на экран Список сотрудников,
     в случае ошибки происходит ее обработка
     
     parameters:
     newEmployee - новый сотрудник для добавления
     */
    private func addingNewEmployeeOnServer(_ newEmployee: Employee) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.addEmployee(employee: newEmployee) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner(from: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner(from: self)
                self.handleError(error: error)
            }
        }
    }
    
    /*
     Метод изменяет данные сотрудника на сервере, в случае ошибки происходит ее обработка
     
     parameters:
     editedEmployee - изменяемый сотрудник
     */
    private func editingEmployeeOnServer(_ editedEmployee: Employee) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.editEmployee(id: editedEmployee.id, editedEmployee: editedEmployee) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner(from: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner(from: self)
                self.handleError(error: error)
            }
        }
    }
    
    /*
     Метод, который проверяет и сохраняет либо нового, либо отредактированного сотрудника,
     в случае ошибки происходит ее обработка
     */
    private func saveEmployee() throws {
        let bindedEmployee = try unbind()
        if possibleEmployeeToEdit != nil {
            editingEmployeeOnServer(bindedEmployee)
        } else {
            addingNewEmployeeOnServer(bindedEmployee)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(error: Error) {
        let employeeError = error as! BaseError
        ErrorAlert.showAlertController(message: employeeError.message, viewController: self)
    }
    
    /*
     Target на кнопку Save - делает валидацию и вызывает метод saveEmployee(),
     в случае ошибки происходит ее обработка
     */
    @objc func saveEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try saveEmployee()
        } catch {
            handleError(error: error)
        }
    }
    
    /*
     Target на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
