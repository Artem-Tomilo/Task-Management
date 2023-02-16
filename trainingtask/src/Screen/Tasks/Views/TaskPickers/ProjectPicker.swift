import Foundation

/*
 
 */
class ProjectPicker: PickerView {
    
    private var projectData = [Project]()
    
    override init(placeholder: String) {
        super.init(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     
     */
    func setData(_ data: [Project]) -> [PickerViewItem] {
        projectData = data
        for i in data {
            let item = PickerViewItem(id: i.id, title: i.name)
            pickerViewData.append(item)
        }
        return pickerViewData
    }
    
    /*
     
     */
    func unbindProject() throws -> Project {
        let value = try Validator.validateTextForMissingValue(text: textField.unbind(),
                                                              message: "Выберите проект")
        guard selectedItem?.title == value,
              let taskProject = projectData.first(where: { $0.id == selectedItem?.id }) else {
            throw BaseError(message: "Не удалось получить проект")
        }
        return taskProject
    }
}
