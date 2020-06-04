//
//  B_2_2Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class B_2_2Register : UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //setup a new user function
       func SetupNewUser () {
             
             Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
                 if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
                 else {
                   print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                   self.SetupFirebaseData()
                     self.navigationController?.popToRootViewController(animated: true)
                 }
             }
             
         }
    
    //create a new list with the new variables
      func InstantiateOwnerList() -> [String : Any] {
          
          let NewUser = [
              
              GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail, //(0)
              GlobalVariables.UserIDs.BusinessName : GlobalVariables.ActualIDs.ActualBusinessName, //(1)
              GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword, //(2)
              GlobalVariables.UserIDs.UserType: GlobalVariables.ActualIDs.ActualUserType, //(3)
              GlobalVariables.UserIDs.UserZipCode: GlobalVariables.ActualIDs.ActualZipCode //(4)
          ]
          
          return NewUser as [String : Any]
          
      }
      
      //setup the firebase for the new owner with a list of owner variables
      func SetupFirebaseData () {
          db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!)").setData(InstantiateOwnerList()) { err in
              if let err = err {
                  print("Error writing document: \(err)")
              } else {
                  print("Document successfully written!")
              }
          }
      }
       
       
    @IBAction func ConfirmBusiness(_ sender: UIButton) {
        //the next few lines set the global data variables as the textfield user inputted data for use in data set.
        GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
        GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
        //***Still need to set the address
        SetupNewUser()
    }
    
    
}
