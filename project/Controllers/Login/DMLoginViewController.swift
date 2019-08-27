import UIKit

class DMLoginViewController: DMViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField  : UITextField!
    @IBOutlet weak var passwordTextField  : UITextField!
    @IBOutlet weak var overlayView        : UIView!
    @IBOutlet weak var createNewAccount   : UIButton!
    @IBOutlet weak var signInButton   : UIButton!
    @IBOutlet weak var fogotButton   : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let notifications: PushNotifications = ServiceLocator.shared.getService()
        notifications.fogotpassword.bindAndFire { url in
            if let url = url {
                self.startResetPassword(url)
                notifications.fogotpassword.value = nil
            }
        }
    }

    // MARK: Private
    
    func startResetPassword(_ url: URL) {
        let token = url.pathComponents[1]
        let udid = url.pathComponents[2]
        let reset: ResetPasswordViewController = UIStoryboard.init(name: "Authorization", bundle: nil)[.ResetPasswordViewController]
        reset.UDID = udid
        reset.token = token
        navigationController?.pushViewController(reset, animated: true)
    }
    
    private func setupUI() {
//        drawBlurOverlay()
        configureLabels()
        configureTextFields()
        configureKeyboard()
        self.overlayView.layer.cornerRadius = 10

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
//        self.overlayView.clipsToBounds      = true
//        self.overlayView.layer.cornerRadius = 7
//        self.overlayView.isBlurEnabled      = true
//        self.overlayView.blurRadius         = 20
//        self.overlayView.isDynamic          = false
//        self.overlayView.tintColor          = UIColor(red: 54 / 255, green: 54 / 255,blue: 54 / 255, alpha: 1)
    }
    
    private func configureLabels() {
        
        createNewAccount.underlineAttriString("CREATE ACCOUNT")
        fogotButton.underlineAttriString("FORGOT PASSWORD?")
    }
    
    private func configureTextFields() {
    
        self.usernameTextField.attributedPlaceholder =
            NSAttributedString(string:"E-mail",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string:"Password",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }
    
    private func successLogin() {
        let terms = storyboard![.TermsAndConditions]
        self.navigationController?.pushViewController(terms, animated: true)
    }
    
    private func proceedLogin() {
        self.showActivityIndicator()
        
        AccountsDataProvider.default().login(self.usernameTextField.text!, self.passwordTextField.text!) { success, error in
            self.dismissActivityIndicator()
            if (success) {
                self.successLogin()
            } else if let error = error {
                self.showAlertWith(message: error)
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

extension UIButton {
    
    func underlineAttriString(_ text: String) {
    let underlineAttriString = NSMutableAttributedString(string: text, attributes:
        [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
    
    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 227.0 / 255.0, green: 47.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0), range: NSRange.init(location: 0, length: underlineAttriString.length))
    underlineAttriString.addAttribute(NSAttributedStringKey.font, value: Fonts.regular(), range: NSRange.init(location: 0, length: underlineAttriString.length))
    
    setAttributedTitle(underlineAttriString, for: .normal)
    }
}
