import Foundation

/*
 
 */
class EndDatePicker: DatePickerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTimeInterval(days: Int) -> TimeInterval {
        return TimeInterval(days*24*60*60)
    }
    
    /*
     Метод получения даты окончания выполнения задачи
     
     parameters:
     startDate - начальная дата выполнения
     days - количество дней между датами из настроек
     Возвращаемое значение - дата окончания выполнения задачи
     */
    func getEndDateFrom(startDate: Date, with days: Int) -> Date {
        let timeInterval = initTimeInterval(days: days)
        let endDate = Date(timeInterval: timeInterval, since: startDate)
        return endDate
    }
    
    /*
     
     */
    override func unbind() throws -> Date {
        let text = try Validator.validateTextForMissingValue(text: textField.unbind(),
                                                             message: "Введите конечную дату")
        if let date = dateFormatter.date(from: text) {
            return date
        } else {
            throw BaseError(message: "Некоректный ввод конечной даты")
        }
    }
}
