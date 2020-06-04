//
//  B_1Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


//this is the CUSTOMER view controller register class
class B_1Register : UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var NameTextField: UITextField! {
        didSet {
            NameTextField.tintColor = UIColor.red
            NameTextField.setIcon(UIImage(systemName: "smiley")!)
        }
    }
    @IBOutlet weak var EmailTextField: UITextField! {
        didSet {
            EmailTextField.tintColor = UIColor.yellow
            EmailTextField.setIcon(UIImage(systemName: "person")!)
        }
    }
    @IBOutlet weak var PasswordTextField: UITextField!{
        didSet {
            PasswordTextField.tintColor = UIColor.green
            PasswordTextField.setIcon(UIImage(systemName: "lock")!)
        }
    }
    @IBOutlet weak var ConfirmPasswordTextField:  UITextField! {
        didSet {
            ConfirmPasswordTextField.tintColor = UIColor.blue
            ConfirmPasswordTextField.setIcon(UIImage(systemName: "lock.fill")!)
        }
    }
    @IBOutlet weak var ErrorLabel : UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        self.NameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.RegisterButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
    
    @IBAction func ConfirmData(_ sender: UIButton) {
        //the next 3 instantiations set the global variables to be used in the final dictionary as what the user inputted in the text fields.
        GlobalVariables.ActualIDs.ActualName = NameTextField.text
        GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
        GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
        SetupNewUser()
        
        
        
        
    }
    
    //returns a new list with the customer variables
    func InstantiateCustomerList() -> [String : Any] {
        //this is the new list that will be created.
        let NewUser = [
            GlobalVariables.UserIDs.UserName : GlobalVariables.ActualIDs.ActualName!,
            GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail!,
            GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword!,
            GlobalVariables.UserIDs.UserType: "Customer",
            GlobalVariables.UserIDs.UserCodeString : "",
            ] as [String : Any]
        
        return NewUser
        
    }
    
    //sets up the firebase data with the new list, creating a new document for a new customer user.
    func SetupFirebaseData () {
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!)").setData(InstantiateCustomerList()) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //setup function for a new user in Firebase
    func SetupNewUser () {
        Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
            if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
            else {
                print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a Customer")
                self.SetupFirebaseData()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func OwnerRegisterButton(_ sender: UIButton) {
        GlobalVariables.ActualIDs.ActualUserType = "Owner"
        
    }
    
    
    
}

