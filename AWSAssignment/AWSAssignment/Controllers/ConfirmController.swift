//
//  ConfirmController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 18/08/25.
//

import UIKit
import Amplify

class ConfirmController: UIViewController, UITextFieldDelegate {

    //MARK:- View Outlet
    @IBOutlet weak var viewBack: UIView!
    
    //MARK:- TextField Outlet
    @IBOutlet weak var txtCode: UITextField!
    
    //MARK:- View Outlet
    @IBOutlet weak var btnConfirm: UIButton!
    
    //MARK:- Variable
    var responseMessage: String?
    var userAttributes: AuthUserAttribute?
    
    let user = Amplify.Auth.getCurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBack.layer.shadowColor = #colorLiteral(red: 1, green: 0.6, blue: 0.1333333333, alpha: 1)
        viewBack.layer.shadowOpacity = 0.8
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 2.8
        viewBack.layer.cornerRadius = 12
        
        txtCode.leftView = AppDelegate().getTextFieldLeftAndRightView()
        txtCode.rightView = AppDelegate().getTextFieldLeftAndRightView()
        txtCode.leftViewMode = .always
        txtCode.rightViewMode = .always
        txtCode.layer.cornerRadius = 12
        txtCode.layer.borderWidth = 0.8
        txtCode.layer.borderColor = UIColor.systemGray5.cgColor
        txtCode.backgroundColor = UIColor.systemGray6
        
        btnConfirm.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        if let user = user {
            print("user.username::: \(user.username)")
        }
        
        fetchUserAttributes { attributes, error in
            if let attributes = attributes {
                if let email = attributes.first(where: { $0.0 == .email })?.1 {
                    print("📧 User email: \(email)")
                }
                if let name = attributes.first(where: { $0.0 == .name })?.1 {
                    print("👤 User name: \(name)")
                }
            }
        }
    }
    
    func fetchUserAttributes(completion: @escaping ([(AuthUserAttributeKey, String)]?, String?) -> Void) {
        Amplify.Auth.fetchUserAttributes { result in
            switch result {
            case .success(let attributes):
                var userInfo: [(AuthUserAttributeKey, String)] = []
                for attribute in attributes {
                    print("Attribute key: \(attribute.key), value: \(attribute.value)")
                    userInfo.append((attribute.key, attribute.value))
                }
                completion(userInfo, nil)
                
            case .failure(let error):
                print("Fetch user attributes failed: \(error)")
                completion(nil, error.errorDescription)
            }
        }
    }
    
    @objc func viewTapped() {
        txtCode.resignFirstResponder()
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickConfirmCodeBtn(_ sender: Any) {
        print("Click to Code Confirm")
        if let root = UIApplication.topViewController() {
            if !isValidTextField(txtCode) {
                showAlertView(
                    title: AlertMsgString().provideAlert,
                    message: AlertMsgString().provideConfirmValidation,
                    viewController: root
                )
            } else {
                confirmSignUp(username: user?.username ?? "AWS User", code: txtCode.text!) { [weak self] error in
                    DispatchQueue.main.async {
                        if error == "Signup confirmed!" {
                            self?.signOut { [weak self] in
                                DispatchQueue.main.async {
                                    self?.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        } else {
                            if let root = UIApplication.topViewController() {
                                showAlertView(
                                    title: AlertMsgString().provideAlert,
                                    message: error ?? "Confirmation failed",
                                    viewController: root
                                )
                            }
                        }
                    }
                }
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        Amplify.Auth.signOut { _ in
          UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("", forKey: "Username")
            UserDefaults.standard.set("", forKey: "Email")
            self.userAttributes = nil
            completion()
        }
    }
        
    func confirmSignUp(username: String, code: String, completion: @escaping (String?) -> Void) {
        if let storedUsername = UserDefaults.standard.string(forKey: "signup_username") {
            print("Username: \(storedUsername)")
            Amplify.Auth.confirmSignUp(for: storedUsername, confirmationCode: code) { result in
                switch result {
                case .success(let confirmResult):
                    if confirmResult.isSignupComplete {
                        self.responseMessage = "Signup confirmed!"
                    }
                    completion(self.responseMessage)
                case .failure(let error):
                    self.responseMessage = "Confirmation failed: \(error.localizedDescription)"
                    completion(self.responseMessage)
                }
            }
        }
    }
}
