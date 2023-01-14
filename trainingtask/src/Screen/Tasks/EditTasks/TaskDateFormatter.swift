import Foundation

/*
 TaskDateFormatter - класс наследник DateFormatter с дополнительными свойствами и методами
 */

class TaskDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd"
    }
    
    required init?(coder aDecoder: NSCoder) {
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
}
