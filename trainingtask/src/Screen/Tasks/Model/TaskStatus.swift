import UIKit

/*
 TaskStatus - перечисление возможных статусов для задачи
 */

enum TaskStatus: String, CaseIterable {
    case notStarted, inProgress, completed, postponed
}
