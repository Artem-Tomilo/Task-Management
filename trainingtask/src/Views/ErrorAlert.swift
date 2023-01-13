import UIKit

/*
 ErrorAlert - класс для вызова алерта при обработке ошибок
 */

class ErrorAlert {
    
    static func showAlertController(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .destructive, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
