//
//  SignUpController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit
import Amplify

class SignUpController: UIViewController, UITextFieldDelegate {

    //MARK:- View Outlet
    @IBOutlet weak var viewBack: UIView!
    
    //MARK:- TextField Outlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    
    //MARK:- Button Outlet
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnCPassword: UIButton!
    
    //MARK:- View Outlet
    @IBOutlet weak var btnSignUp: UIButton!
    
    //MARK:- Variable
    var errorMessage: String?
    var userAttributes: AuthUserAttribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBack.layer.shadowColor = #colorLiteral(red: 1, green: 0.6, blue: 0.1333333333, alpha: 1)
        viewBack.layer.shadowOpacity = 0.8
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 2.8
        viewBack.layer.cornerRadius = 12
        
        txtUsername.leftView = AppDelegate().getTextFieldLeftAndRightView()
        txtUsername.rightView = AppDelegate().getTextFieldLeftAndRightView()
        txtUsername.leftViewMode = .always
        txtUsername.rightViewMode = .always
        txtUsername.layer.cornerRadius = 12
        txtUsername.layer.borderWidth = 0.8
        txtUsername.layer.borderColor = UIColor.systemGray5.cgColor
        txtUsername.backgroundColor = UIColor.systemGray6
        
        txtEmailID.leftView = AppDelegate().getTextFieldLeftAndRightView()
        txtEmailID.rightView = AppDelegate().getTextFieldLeftAndRightView()
        txtEmailID.leftViewMode = .always
        txtEmailID.rightViewMode = .always
        txtEmailID.layer.cornerRadius = 12
        txtEmailID.layer.borderWidth = 0.8
        txtEmailID.layer.borderColor = UIColor.systemGray5.cgColor
        txtEmailID.backgroundColor = UIColor.systemGray6
        
        txtPassword.leftView = AppDelegate().getTextFieldLeftAndRightView()
        txtPassword.rightView = AppDelegate().getTextFieldLeftAndRightView()
        txtPassword.leftViewMode = .always
        txtPassword.rightViewMode = .always
        txtPassword.layer.cornerRadius = 12
        txtPassword.layer.borderWidth = 0.8
        txtPassword.layer.borderColor = UIColor.systemGray5.cgColor
        txtPassword.backgroundColor = UIColor.systemGray6
        
        txtCPassword.leftView = AppDelegate().getTextFieldLeftAndRightView()
        txtCPassword.rightView = AppDelegate().getTextFieldLeftAndRightView()
        txtCPassword.leftViewMode = .always
        txtCPassword.rightViewMode = .always
        txtCPassword.layer.cornerRadius = 12
        txtCPassword.layer.borderWidth = 0.8
        txtCPassword.layer.borderColor = UIColor.systemGray5.cgColor
        txtCPassword.backgroundColor = UIColor.systemGray6
        
        btnSignUp.layer.cornerRadius = 12
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPasswordHideShowBtn(_ sender: Any) {
        if(txtPassword.isSecureTextEntry == true) {
            txtPassword.isSecureTextEntry = false
            btnPassword.setImage(UIImage(named: "eye"), for: .normal)
        }else {
            txtPassword.isSecureTextEntry = true
            btnPassword.setImage(UIImage(named: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func onClickCPasswordHideShowBtn(_ sender: Any) {
        if(txtCPassword.isSecureTextEntry == true) {
            txtCPassword.isSecureTextEntry = false
            btnCPassword.setImage(UIImage(named: "eye"), for: .normal)
        }else {
            txtCPassword.isSecureTextEntry = true
            btnCPassword.setImage(UIImage(named: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func onClickSignUpBtn(_ sender: Any) {
        print("Click To SignUp")
        
        if let root = UIApplication.topViewController() {
            if(!isValidTextField(txtUsername)) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideUsernameValidation, viewController: root)
            }else if !isValidTextField(txtEmailID) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideMailValidation, viewController: root)
            }else if isValidEmail(emailID: txtEmailID.text!) == false {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideValidMailValidation, viewController: root)
            }else if !isValidTextField(txtPassword) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().providePasswordValidation, viewController: root)
            }else if txtPassword.text?.count ?? 0 < 6 || txtCPassword.text?.count ?? 0 < 6 {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().providePasswordDigitValidation, viewController: root)
            }else if !isValidTextField(txtCPassword) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideCPasswordValidation, viewController: root)
            }else if txtPassword.text != txtCPassword.text {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideEqualValidation, viewController: root)
            }else {
                signUpConfirmation()
            }
        }
    }
    
    @objc private func signUpConfirmation() {
       signUp(username: txtEmailID.text!, password: txtPassword.text!, email: txtEmailID.text!, name: txtUsername.text!) { [weak self] error in
           DispatchQueue.main.async {
               if error == "Signup complete." {
                   let confirmVC = Storyboard_main.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmController
                   self?.navigationController?.pushViewController(confirmVC, animated: true)
               }else {
                   if let root = UIApplication.topViewController() {
                       showAlertView(title: AlertMsgString().provideAlert, message: error ?? "Signup failed", viewController: root)
                   }
               }
           }
       }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtEmailID.becomeFirstResponder()
        }else if textField == txtEmailID {
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword {
            txtCPassword.becomeFirstResponder()
            txtCPassword.becomeFirstResponder()
        }else if textField == txtCPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func signUp(username: String, password: String, email: String, name: String, completion: @escaping (String?) -> Void) {
        let attributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.name, value: name)
        ]

        let options = AuthSignUpRequest.Options(userAttributes: attributes)
                
        Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { result in
            switch result {
            case .success(let signUpResult):
                let storedUsername = username
                UserDefaults.standard.set(storedUsername, forKey: "signup_username")
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Confirm the user with details sent to - \(deliveryDetails?.destination)")
                    self.errorMessage = "Signup complete."
                    completion(self.errorMessage)
                } else {
                    self.errorMessage = "Signup complete."
                    completion(self.errorMessage)
                }
            case .failure(let error):
                print("SignUp failed: \(error)")
                completion(error.errorDescription)
            }
        }
    }
}
