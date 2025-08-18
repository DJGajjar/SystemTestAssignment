//
//  AppDelegate.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit
import Amplify
import AmplifyPlugins
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func sharedAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                       
        IQKeyboardManager.shared.isEnabled = true
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with Auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return false
    }
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return false
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK - TextField Padding Method
    func getTextFieldLeftAndRightView() -> UIView {
        let paddingView: UIView = UIView.init(frame: CGRect(x:0, y: 0, width:10, height:10))
        return paddingView
        
    }
    
    func getTextFieldLeftAndRightViewInEditProfile() -> UIView {
        let paddingView: UIView = UIView.init(frame: CGRect(x:0, y: 0, width:10, height:5))
        return paddingView
    }
    
    func getTextFieldLeftAndRight_1View() -> UIView {
        let paddingView: UIView = UIView.init(frame: CGRect(x:0, y: 0, width:10, height:10))
        return paddingView
        
    }
    
    func getTextFieldLeftAndRightViewInEdit_1Profile() -> UIView {
        let paddingView: UIView = UIView.init(frame: CGRect(x:0, y: 0, width:10, height:5))
        return paddingView
    }
}

