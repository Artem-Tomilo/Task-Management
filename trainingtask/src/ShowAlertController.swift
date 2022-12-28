//
//  ShowAlertController.swift
//  trainingtask
//
//  Created by Артем Томило on 28.12.22.
//

import UIKit

class ShowAlertController {
    func showAlertController(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .destructive, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
