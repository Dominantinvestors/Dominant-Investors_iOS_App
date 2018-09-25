import UIKit

class DMLoginViewController: DMViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField  : UITextField!
    @IBOutlet weak var passwordTextField  : UITextField!
    @IBOutlet weak var overlayView        : FXBlurView!
    @IBOutlet weak var createNewAccount   : UIButton!
    @IBOutlet weak var signInButton   : UIButton!
    @IBOutlet var backgroundImageView     : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private
    
    private func setupUI() {
        drawBlurOverlay()
        configureLabels()
        configureTextFields()
        configureKeyboard()
        
        self.signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
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
    
    private func configureLabels() {
        let underlineAttriString = NSMutableAttributedString(string:"CREATE ACCOUNT", attributes:
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: underlineAttriString.length))
        underlineAttriString.addAttribute(NSAttributedStringKey.font, value: Fonts.regular(), range: NSRange.init(location: 0, length: underlineAttriString.length))
        
        createNewAccount.setAttributedTitle(underlineAttriString, for: .normal)
    }
    
    private func configureTextFields() {
    
        self.usernameTextField.attributedPlaceholder =
            NSAttributedString(string:"USERNAME",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string:"PASSWORD",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }
    
    private func showTabBar() {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func proceedLogin() {
        self.showActivityIndicator()
        
        AccountsDataProvider.default().login(self.usernameTextField.text!, self.passwordTextField.text!) { success, error in
            self.dismissActivityIndicator()
            if (success) {
                self.showTabBar()
            } else if let error = error {
                self.showAlertWith(title: NSLocalizedString("Authorization error", comment: ""),
                                   message: error,
                                   cancelButton: false)
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(sender : UIButton) {
        self.proceedLogin()
    }


    @IBAction func signUpButtonPressed(sender : UIButton) {
        let signUp = UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "DMSignUpViewController")
        
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 3) {
            self.proceedLogin()
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
