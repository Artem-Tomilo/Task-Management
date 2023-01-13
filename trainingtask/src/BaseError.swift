import Foundation

/*
 Структура типовой ошибки, обрабатываемой в приложении
 */

struct BaseError: Error {
    
    var message: String // Сообщение этой ошибки, отображаемое в alert
    
    init(message: String) {
        self.message = message
    }
}
