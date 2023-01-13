import UIKit

/*
 ProjectEditViewController - экран Редактирование проекта, отображает необходимые поля для введения нового, либо редактирования существующего проекта
 */

class ProjectEditViewController: UIViewController {
    
    private let projectEditView = ProjectEditView()
    weak var delegate: ProjectEditViewControllerDelegate? // объект делегата для ProjectEditViewControllerDelegate
    var possibleProjectToEdit: Project? // свойство, в которое будет записываться передаваемый проект для редактирования
    
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
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProjectButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод получает данные из текстФилдов экрана и собирает модель проекта
     
     Возвращаемое значение - проект
     */
    private func unbind() -> Project {
        let name = projectEditView.unbindProjectName()
        let description = projectEditView.unbindProjectDescription()
        
        let project = Project(name: name, description: description)
        return project
    }
    
    /*
     Метод, который привязывает новые данные для редактируемого проекта
     
     parameters:
     editedProject - редактируемый проект
     */
    private func editingProject(editedProject: Project) {
        let bindedProject = unbind()
        
        var project = editedProject
        project.name = bindedProject.name
        project.description = bindedProject.description
        delegate?.editProject(self, editedProject: project)
    }
    
    /*
     Метод, который создает новый проект
     */
    private func createNewProject() {
        let newProject = unbind()
        delegate?.addNewProject(self, newProject: newProject)
    }
    
    /*
     Метод проверки введенных значений, если значение не введено - будет выбрасываться соответствующая ошибка
     */
    private func validationOfEnteredData() throws {
        guard projectEditView.unbindProjectName() != "" else {
            throw BaseError(message: "Введите название")
        }
        guard projectEditView.unbindProjectDescription() != "" else {
            throw BaseError(message: "Введите описание")
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
     Метод, который проверяет и сохраняет либо новый, либо отредактированный проект, в случае ошибки происходит ее обработка
     */
    private func saveProject() {
        do {
            try validationOfEnteredData()
            if let editedProject = possibleProjectToEdit {
                editingProject(editedProject: editedProject)
            } else {
                createNewProject()
            }
        }
        catch {
            handleError(error: error)
        }
    }
    
    /*
     Target на кнопку Save - вызывает метод saveProject()
     */
    @objc func saveProjectButtonTapped(_ sender: UIBarButtonItem) {
        saveProject()
    }
    
    /*
     Target на кнопку Cancel - возвращает на предыдущий экран
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.addProjectDidCancel(self)
    }
    
    /*
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
