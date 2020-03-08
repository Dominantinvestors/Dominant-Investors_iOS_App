import UIKit

class ResetPasswordViewController: DMViewController, UITextFieldDelegate {
    
    var UDID: String!
    var token: String!
    
    @IBOutlet weak var passwordTextField  : UITextField!
    @IBOutlet weak var confirmTextField  : UITextField!
    @IBOutlet weak var overlayView        : FXBlurView!
    @IBOutlet weak var confirmButton   : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        drawBlurOverlay()
        configureTextFields()
        configureKeyboard()
        
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2
    }
    
    private func configureKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func drawBlurOverlay() {
        self.overlayView.clipsToBounds      = true
        self.overlayView.layer.cornerRadius = 7
        self.overlayView.isBlurEnabled      = true
        self.overlayView.blurRadius         = 20
        self.overlayView.isDynamic          = false
        self.overlayView.tintColor          = UIColor.lightGray
    }
    
    private func configureTextFields() {
        
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string:"Password",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        self.confirmTextField.attributedPlaceholder =
            NSAttributedString(string:"Confirm",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.confirmTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }
    
    private func proceedReset() {
        showActivityIndicator()
        AccountsDataProvider.default().confirmresetpassword(passwordTextField.text ?? "",
                                                            confirm: confirmTextField.text ?? "",
                                                            UDID: UDID,
                                                            token: token)
            .done { _ in
                self.done()
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
    
    @IBAction func resetButtonPressed(sender : UIButton) {
        self.proceedReset()
    }
    
    @IBAction func backButtonPressed(sender : UIButton) {
        done()
    }
    
    func done() {
       navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 3) {
            self.proceedReset()
        }
        
        let nextField = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextField) as UIResponder? {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil;
        
        if (textField.tag == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = -150
            })
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.configureTextFields()
        
        if (textField.tag == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
    
}

