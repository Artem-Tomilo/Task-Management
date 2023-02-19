import UIKit

/**
 View, отображающее спиннер при загрузке данных
 */
class SpinnerView: UIView {
    
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureUI(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            heightAnchor.constraint(equalToConstant: 80),
            widthAnchor.constraint(equalToConstant: 80)
        ])
        backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        layer.cornerRadius = 10
    }
    
    /**
     Метод для отображения SpinnerView
     
     - parameters:
        - viewController: контроллер, в котором вызывается данный метод
     */
    func showSpinner(viewController: UIViewController) {
        viewController.view.addSubview(self)
        configureUI(view: viewController.view)
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        indicator.startAnimating()
    }
    
    /**
     Метод для скрытия SpinnerView
     */
    func hideSpinner() {
        indicator.stopAnimating()
        removeFromSuperview()
    }
}
