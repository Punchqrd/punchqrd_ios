//
//  LoginScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/25/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import MaterialComponents
import GooglePlaces
import GoogleMaps
import Lottie






class LoginScreen : UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    let newView = UIView()
    let animationView = AnimationView()
    
    
    
    
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    
    let db = Firestore.firestore()
    @IBOutlet weak var EmailTextField: UITextField! {
        didSet {
            EmailTextField.tintColor = UIColor.red
            EmailTextField.setIcon(UIImage(systemName: "person")!)
        }
    }
    @IBOutlet weak var PasswordTextField: UITextField! {
        didSet {
            PasswordTextField.tintColor = UIColor.red
            PasswordTextField.setIcon(UIImage(systemName: "lock")!)
        }
        
    }
    @IBOutlet weak var ErrorLabel : UILabel!
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

    }
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.PasswordTextField.delegate = self
        self.EmailTextField.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined
               {
                   locationManager.requestWhenInUseAuthorization()
                   locationManager.delegate = self
                   locationManager.startUpdatingLocation()
                   
               }
               
        self.locationManager.delegate = self

    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let isLoggedIn = defaults.bool(forKey: GlobalVariables.UserIDs.isUserLoggedIn)
               if isLoggedIn == true {
                   self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)
               }
           
        self.locationManager.delegate = self
        GlobalFunctions.setButtonRadius(button: self.LoginButton)
        self.navigationController?.navigationBar.isHidden = true
        PasswordTextField.text = nil
        EmailTextField.text = nil
        ErrorLabel.text = nil
        self.removeLoadingView()
      
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //login button
    @IBAction func LoginAction(_ sender: UIButton) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        login()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func addLoadingView() {
        
        self.setupAnimation()
    }
    func setupAnimation() {
        let animationNames : [String] = ["CroissantLoader", "BeerLoader", "PizzaLoader", "CoffeeLoader"]
        let randomNumber = Int.random(in: 0...3)
        self.animationView.animation = Animation.named(animationNames[randomNumber])
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
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func ForgotPassword(_ sender: UIButton) {
        if let text = self.EmailTextField.text, text.isEmpty {
            self.resetButtonWithNoEmailPopup(title: "input your email address", message: nil)
        } else {
            resetButtonWithEmailPopup(title: "How would you like to reset?", message: nil)
        }
    }
    
   
    func resetButtonWithNoEmailPopup(title : String?, message : String?) {
            //popup notifying the user to enter email.
            let enterEmailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                      enterEmailAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                          enterEmailAlert.dismiss(animated: true, completion: nil)
                      }))
                      self.present(enterEmailAlert, animated: true)
        
        }
          
    
    
    func resetButtonWithEmailPopup(title : String?, message : String?) {
       //popup with the send verifiction email
                  let resetEmail = UIAlertController(title: title, message: message, preferredStyle: .alert)
                  resetEmail.addAction(UIAlertAction(title: "Reset via email", style: UIAlertAction.Style.default, handler: { (action) in
                      let db = Auth.auth()
                      db.sendPasswordReset(withEmail: self.EmailTextField.text!) { (error) in
                          if let error = error {self.ErrorLabel.text = error.localizedDescription}
                      }
                      resetEmail.dismiss(animated: true, completion: nil)
                  }))
        
        
        let cancel = UIAlertController(title: title, message: message, preferredStyle: .alert)
        resetEmail.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            
            cancel.dismiss(animated: true, completion: nil)
        }))
        
                  self.present(resetEmail, animated: true)
    
    }
    
    
    
   
    
    
    
    //login function
    func login () {
        self.addLoadingView()
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (user, error) in
            if error != nil { self.ErrorLabel.text = error?.localizedDescription
                self.removeLoadingView()
            }
            else {
                
                let user = Auth.auth().currentUser
                switch user!.isEmailVerified {
                    
                case true:
                    
                    //fetch the document array for the user.
                    let document = self.db.collection(GlobalVariables.UserIDs.CollectionTitle).document(self.EmailTextField.text!)
                    //we not have a document
                    document.getDocument { (dataPiece, error) in
                        if let dataPiece = dataPiece, dataPiece.exists {
                            GlobalVariables.ActualIDs.CurrentUser = self.EmailTextField.text!
                            let data = dataPiece.get(GlobalVariables.UserIDs.UserType) as! String
                            if data == GlobalVariables.UserIDs.UserDeletedType {
                                let user = Auth.auth().currentUser
                                user?.delete(completion: { (error) in
                                    if let error = error { print(error.localizedDescription)}
                                    else {
                                        
                                        self.logoutAlert(title: "Your employee \(self.EmailTextField.text!) has been deleted from your list", message: nil)
                                        self.EmailTextField.text = nil
                                        self.PasswordTextField.text = nil
                                    }
                                })
                            }
                            
                            if data == GlobalVariables.UserIDs.UserCustomer {
                                self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)
                                //UIView.setAnimationsEnabled(true)
                            }
                            if data == GlobalVariables.UserIDs.UserEmployee {
                                
                                let businessName = dataPiece.get(GlobalVariables.UserIDs.EmployerString) as! String
                                GlobalFunctions.employeeLocationForLogin(employeeEmployerBusinessName: businessName, navigationController: self, errorLabel: self.ErrorLabel)
                                
                                
                                
                            }
                            if data == GlobalVariables.UserIDs.UserOwner {
                                self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToOwnerHomeScreen, sender: self)
                                
                                
                            }
                            
                        }
                        
                        else {self.ErrorLabel.text = "User does not exist!"
                            self.removeLoadingView()
                        }
                           
                        
                    }
                    
                case false:
                    self.removeLoadingView()
                    self.verifyEmailAlert(title: "Psst", message: "Verify your account before logging in", currentuser : user!)
                }
                
            }
        }
    }
    
    func verifyEmailAlert(title : String?, message : String?, currentuser: User?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Send Again", style: .default, handler: {(action) in
            currentuser?.sendEmailVerification(completion: { (error) in
                if let error = error {self.ErrorLabel.text = error.localizedDescription} else {
                    
                    self.ErrorLabel.text = "Check your email!"
                }
            })
        }))
        
        self.present(alert, animated: true)
        
        
    }
    
    
    func logoutAlert(title : String?, message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true)
    }
    
    
}


//extension to add images to textfield
extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
