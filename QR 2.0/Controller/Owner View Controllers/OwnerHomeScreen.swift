//
//  OwnerHomeScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/26/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import AVKit


class OwnerHomeScreen : UIViewController {
    
    @IBOutlet weak var RemoveEmployeeButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var AddEmployeeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.email)
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //show the navigation bar
        // Remove the background color.
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        self.navigationController?.navigationBar.isHidden = false
        GlobalFunctions.setButtonRadius(button: self.AddEmployeeButton)
        GlobalFunctions.setButtonRadius(button: self.RemoveEmployeeButton)
    }
    
    @IBAction func AddEmployeeAction(_ sender: UIButton) {
        
    }
    
    @IBAction func RemoveEmployeeAction(_ sender: UIButton) {
        
    }
    
    
    //logout the owner
    @IBAction func LogoutButton(_ sender: UIBarButtonItem) {
        logoutAlert(title: "Logout?", message: nil)
    }
    
    func logoutAlert(title : String?, message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                //send the user back to the homescreen
                self.navigationController?.popToRootViewController(animated: true)
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
