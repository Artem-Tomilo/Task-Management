import UIKit

/*
 EmployeeEditViewController - экран Редактирование сотрудника, отображает необходимые поля для введения нового,
 либо редактирования существующего сотрудника
 */
class EmployeeEditViewController: UIViewController {
    
    private let employeeEditView = EmployeeEditView()
    private let spinnerView = SpinnerView()
    
    private var possibleEmployeeToEdit: Employee?
    private let server: Server
    
    init(server: Server, possibleEmployeeToEdit: Employee?) {
        self.server = server
        self.possibleEmployeeToEdit = possibleEmployeeToEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
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
            employeeEditView.bind(EmployeeDetails(surname: employeeToEdit.surname,
                                                  name: employeeToEdit.name,
                                                  patronymic: employeeToEdit.patronymic,
                                                  position: employeeToEdit.position))
        } else {
            title = "Добавление сотрудника"
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveEmployeeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод получает данные из текстФилдов экрана в виде редактируемой модели, делает валидацию и передает ее дальше
     
     Возвращаемое значение - редактируемая модель сотрудника
     */
    private func unbind() throws -> EmployeeDetails {
        return try employeeEditView.unbind()
    }
    
    /*
     Метод добавляет нового сотрудника в массив на сервере и возвращает на экран Список сотрудников,
     в случае ошибки происходит ее обработка
     
     parameters:
     newEmployee - редактируемая модель сотрудника для добавления
     */
    private func addingNewEmployeeOnServer(_ newEmployee: EmployeeDetails) {
        self.spinnerView.showSpinner(viewController: self)
        server.addEmployee(employeeDetails: newEmployee) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
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
        server.editEmployee(id: editedEmployee.id, editedEmployee: editedEmployee) { result in
            switch result {
            case .success():
                self.spinnerView.hideSpinner()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.spinnerView.hideSpinner()
                self.handleError(error)
            }
        }
    }
    
    /*
     Метод, который проверяет и сохраняет либо нового, либо отредактированного сотрудника,
     в случае ошибки происходит ее обработка
     */
    private func saveEmployee() throws {
        let bindedEmployee = try unbind()
        if let possibleEmployeeToEdit {
            let employee = Employee(surname: bindedEmployee.surname,
                                    name: bindedEmployee.name,
                                    patronymic: bindedEmployee.patronymic,
                                    position: bindedEmployee.position, id: possibleEmployeeToEdit.id)
            editingEmployeeOnServer(employee)
        } else {
            addingNewEmployeeOnServer(bindedEmployee)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
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
            handleError(error)
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
