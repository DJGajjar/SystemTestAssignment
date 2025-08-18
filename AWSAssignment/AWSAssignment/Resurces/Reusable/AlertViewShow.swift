//
//  AlertViewShow.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import Foundation
import UIKit

func showAlertView(title: String, message: String, viewController: UIViewController) {
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alertView, animated: true, completion: nil)
}

func isValidEmail(emailID:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailID)
}

func isValidTextField(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    
    // Check if text is empty or contains only whitespaces
    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    return !trimmedText.isEmpty
}

func showConfirmationAlert(on viewController: UIViewController,
                                      title: String,
                                      message: String,
                                      yesTitle: String = "Yes",
                                      noTitle: String = "No",
                                      yesHandler: @escaping () -> Void) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let yesAction = UIAlertAction(title: yesTitle, style: .destructive) { _ in
        yesHandler()
    }
    
    let noAction = UIAlertAction(title: noTitle, style: .cancel, handler: nil)
    
    alert.addAction(yesAction)
    alert.addAction(noAction)
    
    viewController.present(alert, animated: true, completion: nil)
}
