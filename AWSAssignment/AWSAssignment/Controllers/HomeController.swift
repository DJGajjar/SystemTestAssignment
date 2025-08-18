//
//  HomeController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit
import Alamofire

class HomeController: UIViewController {

    //MARK:- TableView Outlet
    @IBOutlet weak var tblTypiCode: UITableView!
    
    // MARK: - Properties
    var aryTypiCode: [TypiCode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        self.tblTypiCode.register(UINib(nibName: "TypicodeCell", bundle: nil), forCellReuseIdentifier: "TypicodeCell")
        self.tblTypiCode.rowHeight = UITableView.automaticDimension
        self.tblTypiCode.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Call Will Appear Method")
        callTypiCodeService()
    }
    
    func callTypiCodeService() {
        let root = UIApplication.topViewController()
        
        if !Reachabilty.isConnectedToNetwork() {
            showAlertView(title: AlertMsgString().provideError, message: AlertMsgString().provideNoInternet, viewController: root!)
            return
        }
    
        showLoading()
        
        AF.request(Path.posts,
              method: .get,
              parameters: nil,
              encoding: URLEncoding.default,
              headers: nil,
              requestModifier: { $0.timeoutInterval = .infinity })
        .responseDecodable(of: [TypiCode].self) { response in
           
           // Hide loading indicator here
           
           self.hideLoading()
           
           print("Get Response Of Posts: \(response.result)")
           
           switch response.result {
           case .success(let posts):
               print("Successfully fetched \(posts.count) posts")
               
               // Store data in array
               self.aryTypiCode = posts
               
               // Reload table view on main thread
               DispatchQueue.main.async {
                   self.tblTypiCode.reloadData()
               }
                                          
           case .failure(let error):
               print("Error fetching posts: \(error.localizedDescription)")
               // Handle different error types
               if let afError = error as? AFError {
                   switch afError {
                   case .responseSerializationFailed(let reason):
                       print("Serialization failed: \(reason)")
                       showAlertView(title: AlertMsgString().provideError, message: AlertMsgString().provideAPIFailed, viewController: root!)
                   case .sessionTaskFailed(let sessionError):
                       print("Session task failed: \(sessionError.localizedDescription)")
                       showAlertView(title: AlertMsgString().provideError, message: sessionError.localizedDescription, viewController: root!)
                   default:
                       print("Other AF Error: \(afError.localizedDescription)")
                       showAlertView(title: AlertMsgString().provideError, message: afError.localizedDescription, viewController: root!)
                   }
               }
               // Show error alert to user
               DispatchQueue.main.async {
                   showAlertView(title: AlertMsgString().provideError, message: AlertMsgString().provideFailedLoad, viewController: root!)
               }
           }
        }
    }
}


//MARK:- Tableview Delegate Datasource
extension HomeController : UITableViewDelegate, UITableViewDataSource {
                 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryTypiCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typicodeCell = tableView.dequeueReusableCell(withIdentifier: "TypicodeCell") as! TypicodeCell
        typicodeCell.selectionStyle = .none
      
        guard indexPath.row < aryTypiCode.count else {
              return typicodeCell
        }
               
        let post = aryTypiCode[indexPath.row]
                
        typicodeCell.lblID.text = "ID: \(post.id)"
        typicodeCell.lblTitle.text = "Title: \(post.title)"
        typicodeCell.lblDescription.text = post.body
        
        return typicodeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Click Cell")
    }
}
