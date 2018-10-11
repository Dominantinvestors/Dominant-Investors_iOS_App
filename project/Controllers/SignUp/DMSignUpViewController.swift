import UIKit
//import MBProgressHUD

class DMSignUpViewController: DMViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton              : UIButton!
    @IBOutlet weak var alreadyHaveAccount        : UIButton!
    
    @IBOutlet weak var firstName            : UITextField!
    @IBOutlet weak var lastName            : UITextField!
    @IBOutlet weak var email         : UITextField!
    @IBOutlet weak var password  : UITextField!
    @IBOutlet weak var confirmPassword         : UITextField!
    
    @IBOutlet var overlayView                    : FXBlurView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private
    private func setupUI() {
        configureTextFields()
        drawBlurOverlay()
        configureKeyboard()
    }
    
    private func drawBlurOverlay() {
        self.overlayView.clipsToBounds      = true
        self.overlayView.layer.cornerRadius = 7
        self.overlayView.isBlurEnabled      = true
        self.overlayView.blurRadius         = 20
        self.overlayView.isDynamic          = false
        self.overlayView.tintColor          = UIColor.lightGray
    }
    
    private func configureKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func configureTextFields() {
        self.firstName.setPlaceholder(NSLocalizedString("First name", comment: ""))
        self.lastName.setPlaceholder(NSLocalizedString("Last name", comment: ""))
        self.email.setPlaceholder(NSLocalizedString("E-MAIL", comment: ""))
        self.password.setPlaceholder(NSLocalizedString("PASSWORD", comment: ""))
        self.confirmPassword.setPlaceholder(NSLocalizedString("CONFIRM PASSWORD", comment: ""))

        self.signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
    }
    
    private func handleSignUp () {

        if (self.password.text!.count < 8) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Password must be at least 8 characters", comment: ""),
                               cancelButton: false)

            return
        } else if (self.password.text != self.confirmPassword.text) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Password not match", comment: ""),
                               cancelButton: false)
            return
        } else if (self.firstName.text!.count < 4), (self.lastName.text!.count < 4) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Username must be at least 4 characters", comment: ""),
                               cancelButton: false)
            return
        }
        
        
        self.showActivityIndicator()
        
        AccountsDataProvider.default().signOn(firstName: firstName.text!,
                                              lastName: lastName.text!,
                                              email: email.text!,
                                              password: password.text!,
                                              confirm: confirmPassword.text!)
        { (success, error) in
                self.dismissActivityIndicator()
                if (success) {
                    self.dismiss(animated: true, completion: nil)
                } else if let error = error {
                    self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                                       message: error,
                                       cancelButton: false)
                }
            }
    }
    
    // MARK: Actions
    @IBAction func signUpButtonPressed(sender : UIButton) {
        handleSignUp()
    }
    
    @IBAction func backToLoginButtonPressed(sender : UIButton) {        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 5) {
            self.handleSignUp()
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
        
        if (textField.tag == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = -150
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.configureTextFields()
        
        if (textField.tag == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
    
}


class TextBackground: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = frame.size.height / 2
    }
}
