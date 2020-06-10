//
//  EmployeeHome.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/8/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EmployeeHome: UIViewController {
    
    @IBOutlet weak var ScanButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.ScanButton)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
               // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        
    }
    
    @IBAction func ScanAction(_ sender: UIButton) {
        
        
    }
    
    
    
    
     @IBAction func Logout(_ sender: UIBarButtonItem) {
        
         logoutAlert(title: "Logout?", message: nil)
     }
     
     
    
     //logout alert
        func logoutAlert(title : String?, message : String?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    
                    //reset the values for the user defaults as false to indicate that the user is logged out
                    
                 self.navigationController?.popToRootViewController(animated: false)
                    
                   
                    print("Logged out the user")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                
            }))
            
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            
            self.present(alert, animated: true)
        }
        
    
    
}
