import UIKit

/*
 ProjectEditViewController - экран Редактирование проекта, отображает необходимые поля для введения нового, либо редактирования существующего проекта
 */

class ProjectEditViewController: UIViewController {
    
    private let projectEditView = ProjectEditView()
    private let spinnerView = SpinnerView()
    
    var possibleProjectToEdit: Project? // свойство, в которое будет записываться передаваемый проект для редактирования
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
        projectEditView.initFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .systemRed
        view.addSubview(projectEditView)
        
        NSLayoutConstraint.activate([
            projectEditView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            projectEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            projectEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let projectToEdit = possibleProjectToEdit {
            title = "Редактирование проекта"
            projectEditView.bind(nameTextFieldText: projectToEdit.name, descriptionTextFieldText: projectToEdit.description)
        } else {
            title = "Добавление проекта"
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveProjectButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод получает данные из текстФилдов экрана, делает валидацию и собирает модель проекта,
     при редактировании заменяет данные редактирумого проекта новыми данными
     
     Возвращаемое значение - проект
     */
    private func unbind() throws -> Project {
        let name = try projectEditView.unbindProjectName()
        let description = try projectEditView.unbindProjectDescription()
        
        var project = Project(name: name, description: description)
        
        if let possibleProjectToEdit {
            project.id = possibleProjectToEdit.id
        }
        return project
    }
    
    /*
     Метод добавляет новый проект в массив на сервере и возвращает на экран Список проектов,
     в случае ошибки происходит ее обработка
     
     parameters:
     newProject - новый проект для добавления
     */
    private func addingNewProjectOnServer(_ newProject: Project) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.addProject(project: newProject) { result in
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
     Метод изменяет данные проекта на сервере, в случае ошибки происходит ее обработка
     
     parameters:
     editedProject - изменяемый проект
     */
    private func editingProjectOnServer(_ editedProject: Project) {
        self.spinnerView.showSpinner(viewController: self)
        serverDelegate.editProject(id: editedProject.id, editedProject: editedProject) { result in
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
     Метод, который проверяет и сохраняет либо новый, либо отредактированный проект, в случае ошибки происходит ее обработка
     */
    private func saveProject() throws {
        let bindedProject = try unbind()
        if possibleProjectToEdit != nil {
            editingProjectOnServer(bindedProject)
        } else {
            addingNewProjectOnServer(bindedProject)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(error: Error) {
        let projectError = error as! BaseError
        ErrorAlert.showAlertController(message: projectError.message, viewController: self)
    }
    
    /*
     Target на кнопку Save - делает валидацию и вызывает метод saveEmployee(),
     в случае ошибки происходит ее обработка
     */
    @objc func saveProjectButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try saveProject()
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
