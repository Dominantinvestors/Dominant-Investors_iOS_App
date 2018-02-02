//
//  DMSignUpViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMSignUpViewController: DMViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton              : UIButton!
    @IBOutlet weak var alreadyHaveAccount        : UIButton!
    
    @IBOutlet weak var loginTextField            : UITextField!
    @IBOutlet weak var emailTextField            : UITextField!
    @IBOutlet weak var passwordTextField         : UITextField!
    @IBOutlet weak var confirmPasswordTextField  : UITextField!
    @IBOutlet weak var inviteIDTextField         : UITextField!
    
    
    @IBOutlet var backgroundImageView            : UIImageView!
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
        self.loginTextField.attributedPlaceholder =
            NSAttributedString(string:"USERNAME",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.emailTextField.attributedPlaceholder =
            NSAttributedString(string:"E-MAIL",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string:"PASSWORD",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.confirmPasswordTextField.attributedPlaceholder =
            NSAttributedString(string:"CONFIRM PASSWORD",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.inviteIDTextField.attributedPlaceholder =
            NSAttributedString(string:"INVITE ID",
                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.loginTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.inviteIDTextField.delegate = self
    }
    
    private func handleSignUp () {
        
        if (self.passwordTextField.text!.length < 8) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Password must be at least 8 characters", comment: ""),
                               cancelButton: false)
            
            return
        } else if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Password not match", comment: ""),
                               cancelButton: false)
            return
        } else if (self.loginTextField.text!.length < 4) {
            self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                               message: NSLocalizedString("Username must be at least 4 characters", comment: ""),
                               cancelButton: false)
            return
        }
        
        
        self.showActivityIndicator()
        DMAuthorizationManager.sharedInstance.signUpWith(login : self.loginTextField.text!,
                                                         email     : self.emailTextField.text!,
                                                         password  : self.passwordTextField.text!,
                                                         confirm   : self.confirmPasswordTextField.text!,
                                                         inviterID : "DEPRECATED FIELD") { (success, error) in
                                                            DispatchQueue.main.async {
                                                                self.dismissActivityIndicator()
                                                                if (success) {
                                                                    self.dismiss(animated: true, completion: nil)
                                                                } else {
                                                                    self.showAlertWith(title: NSLocalizedString("Sign up error", comment: ""),
                                                                                       message: error!.description,
                                                                                       cancelButton: false)
                                                                }
                                                            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func signUpButtonPressed(sender : UIButton) {
        handleSignUp()
    }
    
    @IBAction func backToLoginButtonPressed(sender : UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 5) {
            self.handleSignUp()
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
