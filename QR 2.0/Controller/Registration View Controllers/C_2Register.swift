//
//  C_2Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class C_2Register : UIViewController, UITextFieldDelegate {
    
    
        
    
        @IBOutlet weak var ErrorLabel: UILabel!
        @IBOutlet weak var CreateEmployeeButton: UIButton!
        @IBOutlet weak var NameField: UITextField! {
            didSet {
                NameField.tintColor = UIColor.green
                NameField.setIcon(UIImage(systemName: "smiley")!)
            }
        }
        @IBOutlet weak var EmailField: UITextField! {
            didSet {
                EmailField.tintColor = UIColor.red
                EmailField.setIcon(UIImage(systemName: "person")!)
            }
        }
        @IBOutlet weak var PasswordField: UITextField! {
            didSet {
                PasswordField.tintColor = UIColor.blue
                PasswordField.setIcon(UIImage(systemName: "lock")!)
            }
        }
        @IBOutlet weak var ConfirmPassWord: UITextField! {
            didSet {
                ConfirmPassWord.tintColor = UIColor.yellow
                ConfirmPassWord.setIcon(UIImage(systemName: "lock.fill")!)
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.NameField.delegate = self
            self.EmailField.delegate = self
            self.PasswordField.delegate = self
            self.ConfirmPassWord.delegate = self
            
            
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        
        override func viewWillAppear(_ animated: Bool) {
            navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
            // Set the shadow color.
            navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
            GlobalFunctions.setButtonRadius(button: self.CreateEmployeeButton)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            
        }
        
        
        
        
        //function to add the users email and password to the authentication system
        func createNewEmployeeAsUser() {
            
            
            
            Auth.auth().createUser(withEmail: self.EmailField.text!, password: self.PasswordField.text!) { (user, error) in
                if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
                else {
                    GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.EmployerBusinessEmail!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!)
                    //after creating the user, destroy the code
                    GlobalFunctions.deleteEmployeeAccessCode(codeValue: GlobalVariables.ActualIDs.employeeAccessCode)
                    //send a verificiation email
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {print(error.localizedDescription)} else {
                            self.verifyEmailAlert(title: "Check your email!", message: "We sent a link to verify your account.", currentuser: nil)
                        }
                    })
                }
                
            }
            
        }
    
    //function to alert the user that the email was sent to the address.
    func verifyEmailAlert(title : String?, message : String?, currentuser: String?) {
                  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                  
                  alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                      self.navigationController?.popToRootViewController(animated: true)
                  }))
                  
                  
                  present(alert, animated: true)
              

          }
       
        
        
        
        @IBAction func CreateEmployee(_ sender: UIButton) {
            self.createNewEmployeeAsUser()
        }
        
        
        
    }
    

    
    

