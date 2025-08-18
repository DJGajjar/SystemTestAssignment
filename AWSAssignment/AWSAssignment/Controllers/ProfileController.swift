//
//  ProfileController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit
import Amplify

class ProfileController: UIViewController {

    //MARK:- View Outlet
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewEmailID: UIView!
    
    //MARK:- View Outlet
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    
    //MARK:- Variable
    var userAttributes: AuthUserAttribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewUserName.layer.shadowColor = #colorLiteral(red: 1, green: 0.6, blue: 0.1333333333, alpha: 1)
        viewUserName.layer.shadowOpacity = 0.8
        viewUserName.layer.shadowOffset = .zero
        viewUserName.layer.shadowRadius = 2.8
        viewUserName.layer.cornerRadius = 12
        
        viewEmailID.layer.shadowColor = #colorLiteral(red: 1, green: 0.6, blue: 0.1333333333, alpha: 1)
        viewEmailID.layer.shadowOpacity = 0.8
        viewEmailID.layer.shadowOffset = .zero
        viewEmailID.layer.shadowRadius = 2.8
        viewEmailID.layer.cornerRadius = 12
            
        lblUserName.text = UserDefaults.standard.string(forKey: "Username")
        lblEmailID.text = UserDefaults.standard.string(forKey: "Email")
    }
        
    @IBAction func onClickLogOutBtn(_ sender: Any) {
        if let root = UIApplication.topViewController() {
            showConfirmationAlert(on: root, title: AlertMsgString().provideAlert, message: AlertMsgString().provideLogOutConfirmation, yesTitle: AlertMsgString().provideYes, noTitle: AlertMsgString().provideNo) {
                self.signOut { [weak self] in
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let loginVC = Storyboard_main.instantiateViewController(withIdentifier: "LoginVC") as! LoginController
                            let navController = UINavigationController(rootViewController: loginVC)
                            navController.isNavigationBarHidden = true
                            window.rootViewController = navController
                            window.makeKeyAndVisible()
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
}
