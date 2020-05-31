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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func AddEmployeeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.EmployeeAddScreenSegue  , sender: self)
    }
    
    //logout the owner
    @IBAction func LogoutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            //send the user back to the homescreen
            
            self.navigationController?.popToRootViewController(animated: true)
            print("Logged out the user")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }
}
