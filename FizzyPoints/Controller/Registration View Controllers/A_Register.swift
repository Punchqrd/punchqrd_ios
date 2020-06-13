//
//  A_Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit


//this is the BUSINESS view controller register class
class A_Register : UIViewController {
    
    
    
    //MARK:- View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Actions
    @IBAction func CustomerButton(_ sender: UIButton) {
        //when the user clicks the customer button, the user is setting itself as a: Customer
        GlobalVariables.ActualIDs.ActualUserType = "Customer"
        //set a segue to the CUSTOMER register controller
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_1RegisterSeque, sender: self)
    }
    
    
    @IBAction func OwnerButton(_ sender: UIButton) {
        //when the user clicks the owner button, thr user is setting itsels as a: Owner
        GlobalVariables.ActualIDs.ActualUserType = "Owner"
        //set a segue to the BUSINESS register controller
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_2RegisterSeque, sender: self)
    }
    
    
}
