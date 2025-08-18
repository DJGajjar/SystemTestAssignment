//
//  LoadingView.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 18/08/25.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView

/// Check Network Rechable
var isReachable: Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
}

//MARK: -
extension UIViewController: NVActivityIndicatorViewable {
        
    // Show LoadingView When API is called
    func showLoading(_ color: UIColor = #colorLiteral(red: 0.163174212, green: 0.2325206101, blue: 0.3331266046, alpha: 1)) {
        let size = CGSize(width: 40, height:40)
        startAnimating(size, type: .ballClipRotate, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    // Hide LoadingView
    func hideLoading() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}
