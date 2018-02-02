//
//  DMLoginViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMLoginViewController: DMViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField  : UITextField!
    @IBOutlet weak var passwordTextField  : UITextField!
    @IBOutlet weak var overlayView        : FXBlurView!
    @IBOutlet weak var createNewAccount   : UIButton!
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
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: underlineAttriString.length))
        underlineAttriString.addAttribute(NSAttributedStringKey.font, value: Fonts.DMMyseoFont, range: NSRange.init(location: 0, length: underlineAttriString.length))
        
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
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(tabBar!, animated: true)
    }
    
    private func proceedLogin() {
        self.showActivityIndicator()
        DMAuthorizationManager.sharedInstance.loginWith(login: self.usernameTextField.text!,
                                                        password: self.passwordTextField.text!) { (success, error) in
                                                            DispatchQueue.main.async {
                                                                self.dismissActivityIndicator()
                                                                if (success) {
                                                                    self.showTabBar()
                                                                } else {
                                                                    self.showAlertWith(title: NSLocalizedString("Authorization error", comment: ""),
                                                                                       message: error!.description,
                                                                                       cancelButton: false)
                                                                }
                                                            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(sender : UIButton) {
        self.proceedLogin()
    }


    @IBAction func signUpButtonPressed(sender : UIButton) {
        let signUp = UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "DMSignUpViewController")
        
        self.present(signUp, animated: false, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 3) {
            self.proceedLogin()
        }
        
        let nextField = textField.tag + 1
        let nextResponder = self.view.viewWithTag(nextField) as UIResponder!
        
        if (nextResponder != nil){
            nextResponder?.becomeFirstResponder()
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
