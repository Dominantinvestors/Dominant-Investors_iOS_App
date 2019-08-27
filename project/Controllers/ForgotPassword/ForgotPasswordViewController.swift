import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        verify.layer.cornerRadius = verify.frame.size.height / 2
        configureKeyboard()
        self.overlayView.layer.cornerRadius = 10
        configureTextFields()
    }

    private func configureKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func configureTextFields() {
        textField.attributedPlaceholder =
            NSAttributedString(string:"E-mail",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
    
        textField.delegate = self
    }
    
    @IBAction private func backButtonPressed(sender : UIButton) {
        done()
    }
    
    @IBAction private func resetButtonPressed(sender : UIButton) {
        reset()
    }
    
    private func reset() {
        showActivityIndicator()
        AccountsDataProvider.default().resetpassword(for: textField.text ?? "").done { _ in
                self.done()
            
            CRNotifications.showNotification(type: .info,
                                             title: NSLocalizedString("Password reset!", comment: ""),
                                             message: NSLocalizedString("Password reset e-mail has been sent.", comment: ""),
                                             dismissDelay: 3)
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
    
    private func done() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reset()
        return true
    }
}
