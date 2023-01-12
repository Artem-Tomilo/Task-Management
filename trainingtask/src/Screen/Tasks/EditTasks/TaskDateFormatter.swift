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
     date - начальная дата выполнения
     days - количество дней между датами из настроек
     Возвращаемое значение - дата окончания выполнения задачи
     */
    func getEndDateFromNumberOfDaysBetweenDates(date: Date, days: Int) -> Date {
        let timeInterval = initTimeInterval(days: days)
        let endDate = Date(timeInterval: timeInterval, since: date)
        return endDate
    }
}
