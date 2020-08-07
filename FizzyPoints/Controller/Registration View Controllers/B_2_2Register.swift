//
//  B_2_2Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import StoreKit
import Lottie

class B_2_2Register : UIViewController, UITextFieldDelegate {
    
    
    let animationView = AnimationView()
    let db = Firestore.firestore()
    
    var EmailTextField = UITextField()
    var PasswordTextField = UITextField()
    var ConfirmPasswordTextField = UITextField()
    var SetupButton = ActionButton(backgroundColor: .black, title: "Setup", image: nil)
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        setupToHideKeyboardOnTapOnView()

        super.viewDidLoad()
        setupView()
        
        navigationController?.navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.black,
              NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        navigationItem.title = "One more step."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeLoadingView()
    }
    
    
    //MARK:- setup view
    func setupView() {
        //bottom up seutp
        
        //button setup
        view.addSubview(SetupButton)
        SetupButton.translatesAutoresizingMaskIntoConstraints = false
        SetupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        SetupButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        SetupButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        SetupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        SetupButton.addTarget(self, action: #selector(ConfirmBusiness), for: .touchUpInside)
        
        //confirm password textfield
        view.addSubview(ConfirmPasswordTextField)
        ConfirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        ConfirmPasswordTextField.widthAnchor.constraint(equalTo: SetupButton.widthAnchor).isActive = true
        ConfirmPasswordTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        ConfirmPasswordTextField.bottomAnchor.constraint(equalTo: SetupButton.topAnchor, constant: 10).isActive = true
        ConfirmPasswordTextField.textColor = .black
        ConfirmPasswordTextField.borderStyle = .none
        ConfirmPasswordTextField.placeholder = "Confirm Password"
        ConfirmPasswordTextField.textAlignment = .left
        ConfirmPasswordTextField.isSecureTextEntry = true
        ConfirmPasswordTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        ConfirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        //password textfield
        view.addSubview(PasswordTextField)
        PasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        PasswordTextField.widthAnchor.constraint(equalTo: SetupButton.widthAnchor).isActive = true
        PasswordTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        PasswordTextField.bottomAnchor.constraint(equalTo: ConfirmPasswordTextField.topAnchor, constant: 10).isActive = true
        PasswordTextField.textColor = .black
        PasswordTextField.borderStyle = .none
        PasswordTextField.placeholder = "Password"
        PasswordTextField.textAlignment = .left
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        PasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        //email textfield
        view.addSubview(EmailTextField)
        EmailTextField.translatesAutoresizingMaskIntoConstraints = false
        EmailTextField.widthAnchor.constraint(equalTo: SetupButton.widthAnchor).isActive = true
        EmailTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        EmailTextField.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: 10).isActive = true
        EmailTextField.textColor = .black
        EmailTextField.borderStyle = .none
        EmailTextField.placeholder = "Email"
        EmailTextField.textAlignment = .left
        EmailTextField.autocapitalizationType = .none
        EmailTextField.autocorrectionType = .no
        EmailTextField.keyboardType = .emailAddress
        EmailTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        EmailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    
    
    //MARK:- Animation functions
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK:- User handling functions
    //setup a new user function
    func SetupNewUser () {
        self.addLoadingView()
        Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
            
            if let error = error {  let alert = UIAlertController(title: String(describing: error.localizedDescription), message: nil, preferredStyle: .alert)
                self.removeLoadingView()
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                    }))
                                      
                self.present(alert, animated: true)
                
            }
            else {
                print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                self.SetupFirebaseData()
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if let error = error {print(error.localizedDescription)} else {
                        self.verifyEmailAlert(title: "Check your email!", message: "We sent a link to verify your account.", currentuser: nil)
                    }
                })
                
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
            GlobalVariables.UserIDs.UserZipCode: GlobalVariables.ActualIDs.ActualZipCode, //(4)
            GlobalVariables.UserIDs.OwnerRegisteredTitle : "false"
        ]
        
        return NewUser as [String : Any]
        
    }
    
    //setup the firebase for the new owner with a list of owner variables
    func SetupFirebaseData () {
        db.collection(GlobalVariables.UserIDs.existingBusinesses).document((GlobalVariables.ActualIDs.ActualZipCode)!).setData(["Owner" : GlobalVariables.ActualIDs.ActualEmail!, "Business Name": GlobalVariables.ActualIDs.ActualBusinessName!])
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!)").setData(InstantiateOwnerList()) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
    @objc func ConfirmBusiness() {
        //the next few lines set the global data variables as the textfield user inputted data for use in data set.
        self.view.endEditing(true)
        if let text = self.ConfirmPasswordTextField.text, !text.isEmpty
        {
            if self.ConfirmPasswordTextField.text! == self.PasswordTextField.text! {
                GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
                GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
                SetupNewUser()
                
            }
            else {
                  let alert = UIAlertController(title: "Make sure both passwords match.", message: nil, preferredStyle: .alert)
                                         
                                         alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
                                             alert.dismiss(animated: true, completion: nil)
                                         }))
                                      
                                              self.present(alert, animated: true)
            }
            
        }
        else {
              let alert = UIAlertController(title: "Confirm your password!", message: nil, preferredStyle: .alert)
                                     
                                     alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
                                         alert.dismiss(animated: true, completion: nil)
                                     }))
                                  
                                          self.present(alert, animated: true)
        }
        
        
    }
    
    
    
}
