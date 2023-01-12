import Foundation

/*
 Протокол TaskEditViewDelegate - интерфейс для взаимодействия с TaskEditView
 */

protocol TaskEditViewDelegate: AnyObject {
    func bindData() -> [String]
}
