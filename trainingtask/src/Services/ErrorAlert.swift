import UIKit

/**
 Класс для вызова алерта при обработке ошибок
 */
class ErrorAlert {
    
    /**
     Метод отображения алерта
     
     - parameters:
        - message: сообщение алерта
        - viewController: контроллер, на котором будет отображаться алерт
     */
    static func showAlertController(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .destructive, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
