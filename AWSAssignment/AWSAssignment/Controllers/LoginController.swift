//
//  LoginController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit
import Amplify

class LoginController: UIViewController, UITextFieldDelegate {

    //MARK:- View Outlet
    @IBOutlet weak var viewBack: UIView!
    
    //MARK:- TextField Outlet
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK:- Button Outlet
    @IBOutlet weak var btnPassword: UIButton!
    
    //MARK:- View Outlet
    @IBOutlet weak var btnSignIn: UIButton!
    
    //MARK:- Variable
    var responseMessage: String?
    var userAttributes: AuthUserAttribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBack.layer.shadowColor = #colorLiteral(red: 1, green: 0.6, blue: 0.1333333333, alpha: 1)
        viewBack.layer.shadowOpacity = 0.8
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 2.8
        viewBack.layer.cornerRadius = 12
        
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
        
        btnSignIn.layer.cornerRadius = 12
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
    
    @IBAction func onClickSignInBtn(_ sender: Any) {
        print("Click TO SignIn")
        if let root = UIApplication.topViewController() {
            if(!isValidTextField(txtEmailID) && !isValidTextField(txtPassword)) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideMailPassValidation, viewController: root)
            }else if !isValidTextField(txtEmailID) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideUsernameValidation, viewController: root)
            }else if isValidEmail(emailID: txtEmailID.text!) == false {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().provideValidMailValidation, viewController: root)
            }else if !isValidTextField(txtPassword) {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().providePasswordValidation, viewController: root)
            }else if txtPassword.text?.count ?? 0 < 6  {
                showAlertView(title: AlertMsgString().provideAlert, message: AlertMsgString().providePasswordDigitValidation, viewController: root)
            }else {
                txtEmailID.resignFirstResponder()
                txtPassword.resignFirstResponder()
                                       
                signIn(username: txtEmailID.text!, password: txtPassword.text!) { [weak self] error in
                    if error == "Signin incomplete" {
                        DispatchQueue.main.async {
                            let tabBarVC = Storyboard_main.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarController
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController = tabBarVC
                                window.makeKeyAndVisible()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if let root = UIApplication.topViewController() {
                                showAlertView(title: AlertMsgString().provideAlert, message: error ?? "Signin failed", viewController: root)
                            }
                        }
                    }
                }

            }
        }
    }
        
    func signIn(username: String, password: String, completion: @escaping (String?) -> Void) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    print("User is signed in")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.fetchUserAttributes { error in
                        if let error = error {
                            completion("Signed in but failed to fetch attributes: \(error)")
                        } else {
                            completion("Signin incomplete")
                        }
                    }
                } else {
                    print("Sign-in not complete. Next step: \(signInResult.nextStep)")
                    Amplify.Auth.resendSignUpCode(for: username) { result in
                        switch result {
                        case .success(let deliveryDetails):
                            print("Confirmation code sent to: \(deliveryDetails.destination)")
                            DispatchQueue.main.async {
                                let confirmVC = Storyboard_main.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmController
                                self.navigationController?.pushViewController(confirmVC, animated: true)
                            }
                        case .failure(let error):
                            print("Resend code failed: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Amplify SignIn Error: \(error)")
                print("Error Description: \(error.errorDescription)")
                completion("Signin failed: \(error.errorDescription)")
            }
        }
    }
    
    private func fetchUserAttributes(completion: @escaping (String?) -> Void) {
        Amplify.Auth.fetchUserAttributes { result in
            switch result {
            case .success(let attributes):
                let name = attributes.first { $0.key == .name }?.value ?? "Unknown"
                let email = attributes.first { $0.key == .email }?.value ?? "Unknown"
                self.userAttributes = AuthUserAttribute(.name, value: name)
                                
                UserDefaults.standard.set(name, forKey: "Username")
                UserDefaults.standard.set(email, forKey: "Email")
                
                completion(nil)
            case .failure(let error):
                print("Fetch attributes failed: \(error)")
                completion(error.localizedDescription)
             }
        }
    }
    
    @IBAction func onClickSignUpBtn(_ sender: Any) {
        print("Click Sign Up")
        let signUpVC = Storyboard_main.instantiateViewController(withIdentifier: "SignVC") as! SignUpController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmailID {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}
