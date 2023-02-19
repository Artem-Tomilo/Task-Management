import Foundation

/**
 Структура типовой ошибки, обрабатываемой в приложении
 */
struct BaseError: Error {
    
    /**
     Сообщение этой ошибки, отображаемое в alert
     */
    var message: String
    
    /**
     Инициализатор структуры
     
     - parameters:
        - message: сообщение для алерта
     */
    init(message: String) {
        self.message = message
    }
}
