import UIKit

/*
 TaskStatus - перечисление возможных статусов для задачи
 
 title - задание русского текста для всех элементов перечисления
 imageView - задание изображения для всех элементов перечисления
 */


enum TaskStatus: String, CaseIterable {
    case notStarted, inProgress, completed, postponed
    
    var title: String {
        switch self {
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
    
    var imageView: UIImage {
        switch self {
        case .notStarted:
            return UIImage(named: "notStarted")!
        case .inProgress:
            return UIImage(named: "inProgress")!
        case .completed:
            return UIImage(named: "completed")!
        case .postponed:
            return UIImage(named: "postponed")!
        }
    }
}
