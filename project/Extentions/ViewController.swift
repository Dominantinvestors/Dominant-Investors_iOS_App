import UIKit
import MBProgressHUD

class DMViewController: UIViewController {
    
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
        let loadingNotification = MBProgressHUD.showAdded(to: aView ?? view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    open func dismissActivityIndicator(_ aView: UIView? = nil) {
        MBProgressHUD.hide(for: aView ?? view, animated: true)
    }
}
