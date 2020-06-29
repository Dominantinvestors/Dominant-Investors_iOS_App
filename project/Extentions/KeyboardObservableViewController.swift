import UIKit

class KeyboardObservableViewController: DMViewController {
    
    @IBOutlet weak internal var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didShow(sender:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didHide(sender:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapOnView() {
        view.endEditing(true)
    }
    
    @objc private func didShow(sender: NSNotification) {
        if let kbSize = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        {
            var height = kbSize.size.height
            
            self.tableView.isScrollEnabled = true
            
            UIView.animate(withDuration: duration, animations: {
                let viewHeight = self.view.frame.size.height
                
                height -= (viewHeight - self.tableView.frame.maxY)
                height += UIApplication.shared.statusBarFrame.height + 120
                
                var edgeInsets = self.tableView.contentInset
                edgeInsets.bottom = height
                
                self.tableView.contentInset = edgeInsets
                
                edgeInsets = self.tableView.scrollIndicatorInsets
                edgeInsets.bottom = height
                
                self.tableView.scrollIndicatorInsets = edgeInsets
            }, completion: { (_) in
                self.tableView.isScrollEnabled = false
            })
        }
    }
    
    @objc private func didHide(sender: NSNotification)  {
        if let duration = sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            self.tableView.isScrollEnabled = true
            
            UIView.animate(withDuration: duration, animations: {
                
                var edgeInsets = self.tableView.contentInset
                edgeInsets.bottom = 0
                
                self.tableView.contentInset = edgeInsets
                
                edgeInsets = self.tableView.scrollIndicatorInsets
                edgeInsets.bottom = 0
                
                self.tableView.scrollIndicatorInsets = edgeInsets
            }, completion: { (_) in
                self.tableView.isScrollEnabled = true
            })
        }
    }
}
