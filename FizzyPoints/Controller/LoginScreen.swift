//
//  LoginScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/25/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//



import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import GooglePlaces
import GoogleMaps
import Lottie
import StoreKit





class LoginScreen : UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    //Variable,Object,Constant Declarations
    let newView = UIView()
    let animationView = AnimationView()
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    
    //Outlet Declarations
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    //UserDefaults setup.
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    
    //MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password:",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //delegate initiations
        self.PasswordTextField.delegate = self
        self.EmailTextField.delegate = self
        self.locationManager.delegate = self
        
        //location manager
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        
        //Keyboard functions
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
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
    
    
    
    //MARK: - Keyboard manipulation
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height/2
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    
    //MARK: - Actions and animations
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
    
    
    //MARK:- Notifications
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
    
    
    
    
    
    //MARK:- Login function
    
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
                                        self.removeLoadingView()
                                    }
                                })
                            }
                            //customer?
                            if data == GlobalVariables.UserIDs.UserCustomer {
                                self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)
                                
                            }
                            //employee?
                            if data == GlobalVariables.UserIDs.UserEmployee {
                                print("Employee")
                                let businessName = dataPiece.get(GlobalVariables.UserIDs.EmployerString) as! String
                                print(businessName)
                                GlobalFunctions.employeeLocationForLogin(employeeEmployerBusinessName: businessName, navigationController: self, errorLabel: self.ErrorLabel, animationView: self.animationView)
                                
                            }
                            //owner?
                            if data == GlobalVariables.UserIDs.UserOwner {
                                self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToOwnerHomeScreen, sender: self)
                                
                            }
                            
                        }
                            //if neither of the three, then the user does not exist.
                        else {self.ErrorLabel.text = "User does not exist!"
                            self.removeLoadingView()
                        }
                        
                        
                    }
                //false case as to whether the user confirmed email
                case false:
                    self.removeLoadingView()
                    self.verifyEmailAlert(title: "Psst", message: "Verify your account before logging in", currentuser : user!)
                }
                
            }
        }
    }
}


//MARK:- (NOT IN USE) UITextfield Extension
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


