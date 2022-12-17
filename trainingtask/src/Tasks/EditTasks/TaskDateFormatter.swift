//
//  TaskDateFormatter.swift
//  trainingtask
//
//  Created by Артем Томило on 17.12.22.
//

import Foundation

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
    
    func getEndDateFromNumberOfDaysBetweenDates(date: Date, days: Int) -> Date {
        let timeInterval = initTimeInterval(days: days)
        let endDate = Date(timeInterval: timeInterval, since: date)
        return endDate
    }
}
