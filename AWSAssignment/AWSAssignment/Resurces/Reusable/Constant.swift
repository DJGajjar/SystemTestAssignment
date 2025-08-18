//
//  Constant.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import Foundation
import UIKit

public var Storyboard_main = UIStoryboard(name: "Main", bundle: nil)

let SHARED_APPDELEGATE = AppDelegate().sharedAppDelegate()

struct BasePath {
    static var Path_IP          = "https://jsonplaceholder.typicode.com/"
}
 
struct Path {
    static let posts          = "\(BasePath.Path_IP)posts"
}

struct AlertMsgString {
    
    static let string = AlertMsgString()
    
    let provideAlert = "Alert"
    let provideError = "Error"
    let provideOk = "Ok"
    let provideYes = "Yes"
    let provideNo = "No"
    let provideCancel = "Cancel"
    let provideFailed = "Failed, Try again!"
    let provideNoData = "No data found"
    
    let provideNoInternet = "No internet connection"
    let provideUserName = "Please enter username"
    
    let provideAPIFailed = "Connection dropped before the response completed"
    let provideFailedLoad = "Failed to load posts. Please try again."
    
    //Login Validation
    let provideMailPassValidation = "Please enter mail and password."
    let provideMailValidation = "Please enter email id."
    let provideValidMailValidation = "Please enter valid email address."
    let providePasswordValidation = "Please enter password."
    let providePasswordDigitValidation = "Please enter at list 6 digit password."
    
    //SignUp Validation
    let provideUsernameValidation = "Please enter username."
    let provideCPasswordValidation = "Please enter confirm password."
    let provideEqualValidation = "Please enter both password equal."
    
    //Confirm Code Validation
    let provideConfirmValidation = "Please enter confirm code."
    
    //LogOut
    let provideLogOutConfirmation = "Are you sure you want to logout?"
}

