//
//  SecondAddEmployeeScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SecondAddEmployeeScreen: UIViewController, UITextFieldDelegate {
    
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
        
        GlobalVariables.ActualIDs.ActualEmail = self.EmailField.text!
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserEmployee
        let currentUser = Auth.auth().currentUser?.email
        Auth.auth().createUser(withEmail: self.EmailField.text!, password: self.PasswordField.text!) { (user, error) in
            if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
            else {
                GlobalFunctions.addEmployee(nameofUser: currentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!)
                print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                self.backTwo()
                
            }
        }
        
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    @IBAction func CreateEmployee(_ sender: UIButton) {
        self.createNewEmployeeAsUser()
    }
    
    
    
}
