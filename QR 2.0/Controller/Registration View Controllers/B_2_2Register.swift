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

class B_2_2Register : UIViewController, UITextFieldDelegate{
    
    let db = Firestore.firestore()
    @IBOutlet weak var EmailTextField: UITextField! {
        didSet {
            EmailTextField.tintColor = UIColor.green
            EmailTextField.setIcon(UIImage(systemName: "person")!)
        }
    }
    @IBOutlet weak var PasswordTextField: UITextField! {
        didSet {
            PasswordTextField.tintColor = UIColor.blue
            PasswordTextField.setIcon(UIImage(systemName: "lock")!)
        }
    }
    @IBOutlet weak var ConfirmPasswordTextField: UITextField! {
        didSet {
            ConfirmPasswordTextField.tintColor = UIColor.red
            ConfirmPasswordTextField.setIcon(UIImage(systemName: "lock.fill")!)
        }
    }
    
    @IBOutlet weak var SetupButton: UIButton!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    override func viewDidLoad() {
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.SetupButton)
        self.navigationItem.backBarButtonItem?.tintColor = .black
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
