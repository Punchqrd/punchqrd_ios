//
//  C_2Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Lottie

class C_2Register : UIViewController, UITextFieldDelegate {
    
    let animationView = AnimationView()
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var CreateEmployeeButton: UIButton!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPassWord: UITextField! 
    
    
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()

        self.NameField.delegate = self
        self.EmailField.delegate = self
        self.PasswordField.delegate = self
        self.ConfirmPassWord.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        GlobalFunctions.setButtonRadius(button: self.CreateEmployeeButton)
    }
    
    
    //MARK:- Animations
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func addLoadingView() {
        self.setupAnimation()
    }
    
    func setupAnimation() {
        
        self.animationView.animation = Animation.named(GlobalVariables.animationTitles.mainLoader)
        self.animationView.frame.size.height = self.view.frame.height
        self.animationView.frame.size.width = self.view.frame.width
        self.animationView.contentMode = .center
        self.animationView.backgroundColor = .white
        self.animationView.play()
        self.animationView.loopMode = .loop
        self.view.addSubview(self.animationView)
    }
    
    func removeLoadingView() {
        self.animationView.stop()
        self.animationView.removeFromSuperview()
        
    }
    
    //MARK:- User handling
    func createNewEmployeeAsUser() {
        
        self.addLoadingView()
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
    
    //MARK:- Alerts
    func verifyEmailAlert(title : String?, message : String?, currentuser: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.removeLoadingView()
        present(alert, animated: true)
        
        
    }
    
    
    //MARK:- Actions
    @IBAction func CreateEmployee(_ sender: UIButton) {
        self.view.endEditing(true)
        if let text = self.ConfirmPassWord.text, !text.isEmpty
        {
            
            if self.ConfirmPassWord.text! == self.PasswordField.text! {
                self.createNewEmployeeAsUser()
                self.resignFirstResponder()
            } else {
                self.ErrorLabel.text = "Make sure both passwords are the same."
            }
            
        }  else {
            self.ErrorLabel.text = "Confirm your password"
        }
        
        
    }
    
    
    
    
}





