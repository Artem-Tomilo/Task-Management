import Foundation

/*
 
 */
class StatusPicker: PickerView {
    
    private var statusData = TaskStatus.allCases
    
    override init(placeholder: String) {
        super.init(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Метод получения статуса в строковом варианте
     
     parameters:
     status - статус задачи
     Возвращаемое значение - строковый вариант статуса
     */
    private func getStatusTitleFrom(_ status: TaskStatus) -> String {
        switch status {
        case .notStarted:
            return "Не начата"
        case .inProgress:
            return "В процессе"
        case .completed:
            return "Завершена"
        case .postponed:
            return "Отложена"
        }
    }
    
    /*
     Метод получения статуса из строки
     
     parameters:
     title - проверяемая строка
     Возвращаемое значение - статус
     */
    private func getStatusFrom(_ title: String) -> TaskStatus? {
        switch title {
        case "Не начата":
            return .notStarted
        case "В процессе":
            return .inProgress
        case "Завершена":
            return .completed
        case "Отложена":
            return .postponed
        default:
            return nil
        }
    }
    
    /*
     
     */
    func setData() -> [PickerViewItem] {
        for i in statusData {
            let item = PickerViewItem(id: i.hashValue, title: getStatusTitleFrom(i))
            pickerViewData.append(item)
        }
        return pickerViewData
    }
    
    /*
     Метод получения текста statusTextField, его проверки и форматирования в тип TaskStatus,
     в случае ошибки происходит ее обработка
     
     Возвращаемое значение - статус
     */
    func unbindStatus() throws -> TaskStatus {
        let value = try Validator.validateTextForMissingValue(text: textField.unbind(),
                                                              message: "Выберите статус")
        let status = getStatusFrom(value)
        guard let status = TaskStatus.allCases.first(where: { $0 == status }) else {
            throw BaseError(message: "Не удалось выбрать статус")
        }
        return status
    }
}
