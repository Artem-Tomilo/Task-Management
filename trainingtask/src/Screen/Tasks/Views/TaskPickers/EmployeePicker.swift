import Foundation

/**
 Picker для работы с полем выбора сотрудника в TaskEditView
 */
class EmployeePicker: PickerView {
    
    private var employeeData = [Employee]()
    
    override init(placeholder: String) {
        super.init(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Метод привязки данных и их перевода в PickerViewItem для работы с базовым Picker'ом
     
     - parameters:
        - data: сотрудники для отображения в пикере
     
     - returns:
     Конвертирумый массив сотрудников в тип PickerViewItem
     */
    func setData(_ data: [Employee]) -> [PickerViewItem] {
        employeeData = data
        for i in data {
            let item = PickerViewItem(id: i.id, title: i.fullName)
            pickerViewData.append(item)
        }
        return pickerViewData
    }
    
    /**
     Метод получения выбранного сотрудника
     
     - returns:
     Выбранный сотрудник
     */
    func unbindEmployee() throws -> Employee {
        let value = try Validator.validateTextForMissingValue(text: textField.unbind(),
                                                              message: "Выберите сотрудника")
        guard selectedItem?.title == value,
              let taskEmployee = employeeData.first(where: { $0.id == selectedItem?.id }) else {
            throw BaseError(message: "Не удалось получить сотрудника")
        }
        return taskEmployee
    }
}
