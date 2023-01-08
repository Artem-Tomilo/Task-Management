import UIKit

/*
 SpinnerView - view, отображающее спиннер при загрузке данных
 */

class SpinnerView: UIView {
    
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     Метод для отображения SpinnerView
     
     parameters:
     viewController - контроллер, в котором вызывается данный метод
     */
    func showSpinner(viewController: UIViewController) {
        frame = viewController.view.bounds
        viewController.view.addSubview(self)
        
        addSubview(indicator)
        backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        indicator.center = center
        indicator.startAnimating()
        
        viewController.navigationController?.navigationBar.alpha = 0.3
    }
    
    /*
     Метод для скрытия SpinnerView
     
     parameters:
     viewController - контроллер, в котором вызывается данный метод
     */
    func hideSpinner(from viewController: UIViewController) {
        indicator.stopAnimating()
        removeFromSuperview()
        viewController.navigationController?.navigationBar.alpha = 1
    }
}
