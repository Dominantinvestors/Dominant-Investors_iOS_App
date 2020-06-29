import UIKit
import NVActivityIndicatorView

class DMViewController: UIViewController {
    
}

extension UIViewController: NVActivityIndicatorViewable {
    
    open func showAlertWith(_ error: Error) {
        showAlertWith(message: error.localizedDescription)
    }
        
    open func showAlertWith(title: String = NSLocalizedString("Error!!!", comment: ""), message: String?, cancelButton: Bool = false) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action) in
            self.okAction()
        }))
        
        if (cancelButton) {
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { (action) in
                self.cancelAction()
            }))
        }
        
        alert.modalPresentationStyle = .fullScreen

        self.present(alert, animated: true) {
            
        }
    }
    
    open func okAction() {
        
    }
    
    open func cancelAction() {
        
    }
    
    open func refreshData() {
        
    }
    
    open func showActivityIndicator(_ aView: UIView? = nil) {
        startAnimating(color: .red, backgroundColor: .clear)
    }
    
    open func dismissActivityIndicator(_ aView: UIView? = nil) {
        stopAnimating()
    }
}
