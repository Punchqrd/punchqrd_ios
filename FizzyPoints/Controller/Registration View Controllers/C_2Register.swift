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
    
    var CreateEmployeeButton = ActionButton(backgroundColor: .systemGreen, title: "Register", image: nil)
    var NameField = UITextField()
    var EmailField = UITextField()
    var PasswordField = UITextField()
    var ConfirmPassWord = UITextField()
    
    
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        
        self.NameField.delegate = self
        self.EmailField.delegate = self
        self.PasswordField.delegate = self
        self.ConfirmPassWord.delegate = self
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        GlobalFunctions.setButtonRadius(button: self.CreateEmployeeButton)
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        navigationItem.title = "Final step."
    }
    
    
    //MARK:- Setup main view.
    func setupView() {
        view.addSubview(CreateEmployeeButton)
        CreateEmployeeButton.translatesAutoresizingMaskIntoConstraints = false
        CreateEmployeeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        CreateEmployeeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        CreateEmployeeButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        CreateEmployeeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        CreateEmployeeButton.addTarget(self, action: #selector(CreateEmployee), for: .touchUpInside)
        
        //confirm password textfield
        view.addSubview(ConfirmPassWord)
        ConfirmPassWord.translatesAutoresizingMaskIntoConstraints = false
        ConfirmPassWord.widthAnchor.constraint(equalTo: CreateEmployeeButton.widthAnchor).isActive = true
        ConfirmPassWord.heightAnchor.constraint(equalToConstant: 75).isActive = true
        ConfirmPassWord.bottomAnchor.constraint(equalTo: CreateEmployeeButton.topAnchor, constant: 10).isActive = true
        ConfirmPassWord.textColor = .black
        ConfirmPassWord.borderStyle = .none
        ConfirmPassWord.placeholder = "Confirm Password"
        ConfirmPassWord.textAlignment = .left
        ConfirmPassWord.isSecureTextEntry = true
        ConfirmPassWord.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        ConfirmPassWord.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        //password textfield
        view.addSubview(PasswordField)
        PasswordField.translatesAutoresizingMaskIntoConstraints = false
        PasswordField.widthAnchor.constraint(equalTo: CreateEmployeeButton.widthAnchor).isActive = true
        PasswordField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        PasswordField.bottomAnchor.constraint(equalTo: ConfirmPassWord.topAnchor, constant: 10).isActive = true
        PasswordField.textColor = .black
        PasswordField.borderStyle = .none
        PasswordField.placeholder = "Password"
        PasswordField.textAlignment = .left
        PasswordField.isSecureTextEntry = true
        PasswordField.autocapitalizationType = .none
        PasswordField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        PasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        //email textfield
        view.addSubview(EmailField)
        EmailField.translatesAutoresizingMaskIntoConstraints = false
        EmailField.widthAnchor.constraint(equalTo: CreateEmployeeButton.widthAnchor).isActive = true
        EmailField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        EmailField.bottomAnchor.constraint(equalTo: PasswordField.topAnchor, constant: 10).isActive = true
        EmailField.textColor = .black
        EmailField.borderStyle = .none
        EmailField.placeholder = "Email"
        EmailField.textAlignment = .left
        EmailField.autocapitalizationType = .none
        EmailField.autocorrectionType = .no
        EmailField.keyboardType = .emailAddress
        EmailField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        EmailField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
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
        let animationTitle = ["CroissantLoader", "CoffeeLoader", "BeerLoader"]
        let randomNumber = Int.random(in: 0...2)
        self.animationView.animation = Animation.named(animationTitle[randomNumber])
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
        Auth.auth().createUser(withEmail: self.EmailField.text!.lowercased(), password: self.PasswordField.text!) { (user, error) in
            if let error = error {
                
                
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
                
            }
            else {
                
                GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.EmployerBusinessEmail!.lowercased(), employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!)
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
    @objc func CreateEmployee() {
        self.view.endEditing(true)
        if let text = self.ConfirmPassWord.text, !text.isEmpty
        {
            
            if self.ConfirmPassWord.text! == self.PasswordField.text! {
                self.createNewEmployeeAsUser()
                self.resignFirstResponder()
            } else {
                
                let alert = UIAlertController(title: "Make sure both passwords are the same.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
        }  else {
            let alert = UIAlertController(title: "Confirm your password.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                return
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
}





