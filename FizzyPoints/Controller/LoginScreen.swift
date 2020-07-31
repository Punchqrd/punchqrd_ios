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
    var containerView = UIView()
    
    var RegisterButton = UIButton()
    var LoginButton = UIButton()
    var EmailTextField = UITextField()
    var PasswordTextField = UITextField()
    var passwordContainerView = UIView()
    var emailContainerView = UIView()
    var ErrorLabel = UILabel()
    
    var forgotPasswordButton = UIButton()
    var questionMarkButton = UIButton()
    var forgotPasswordView = UIView()
    
    let homeAnimation = AnimationView()
    var logoView = UIImageView()
    let backGroundView = UIView()

    
    
    
    //UserDefaults setup.
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    
    //MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        setupToHideKeyboardOnTapOnView()
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
        self.view.backgroundColor = .systemPurple
        let isLoggedIn = defaults.bool(forKey: GlobalVariables.UserIDs.isUserLoggedIn)
        let isFirstTime = defaults.bool(forKey: GlobalVariables.UserIDs.isUserFirstTime)
        if isLoggedIn == true {
            self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)
        }
        if isFirstTime == true {
            print("Yes")
                let newView = OnboardingView(parentView: self.view)
                newView.setupMainView()
                newView.setupFirstView()
        }
        
        if isFirstTime == false {
               print("OK")
        }
        
        self.locationManager.delegate = self
        GlobalFunctions.setButtonRadius(button: self.LoginButton)
        self.navigationController?.navigationBar.isHidden = true
        PasswordTextField.text = nil
        EmailTextField.text = nil
        ErrorLabel.text = nil
        self.removeLoadingView()
        setupView()
        
    }
    
    //setup the visual interface
    func setupView() {
        
        
       
        
        logoView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        logoView.center.x = self.view.frame.width/2
        logoView.center.y = self.view.frame.height/5
        //logo setup
       
        let imageName = "Home Screen Inverse"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: logoView.frame.size.width, height: logoView.frame.size.height)
        logoView.addSubview(imageView)
        
        self.view.addSubview(logoView)
        
        //home animation setup
//        self.homeAnimation.animation = Animation.named("HomeAnimation")
//        self.homeAnimation.frame.size.height =  self.view.frame.width/2
//        self.homeAnimation.frame.size.width = self.view.frame.width/2
//        self.homeAnimation.center.x = self.view.frame.size.width/2
//        self.homeAnimation.center.y = logoView.center.y
//        self.homeAnimation.contentMode = .center
//        self.homeAnimation.backgroundColor = .clear
//        self.homeAnimation.play()
//        self.homeAnimation.loopMode = .loop
//        self.homeAnimation.contentMode = .scaleAspectFit
//        self.view.addSubview(self.homeAnimation)
//        self.view.sendSubviewToBack(homeAnimation)
        
        //setup the container view
        containerView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        containerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        containerView.center.x = self.view.frame.size.width/2
        containerView.center.y = self.view.center.y
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.cornerRadius = 30
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.33
        

        
        //setup the buttons
        LoginButton.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width - 60, height: containerView.frame.size.height/4)
        LoginButton.center.x = containerView.frame.size.width/2
        LoginButton.center.y = containerView.frame.size.height/1.3
        LoginButton.backgroundColor = .systemBlue
        LoginButton.layer.cornerRadius = 25
        LoginButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.setTitle("Login", for: .normal)
        LoginButton.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        containerView.addSubview(LoginButton)
        
        //setup the fields
        passwordContainerView.frame = CGRect(x: 0, y: 0, width: LoginButton.frame.size.width, height: containerView.frame.size.height/4.8)
        passwordContainerView.center.x = containerView.frame.size.width/2
        passwordContainerView.center.y = containerView.frame.size.height/2
        passwordContainerView.backgroundColor = .white
        passwordContainerView.layer.cornerRadius = 25
        containerView.addSubview(passwordContainerView)
        
        PasswordTextField.frame = CGRect(x: 0, y: 0, width: passwordContainerView.frame.size.width - 30, height: passwordContainerView.frame.size.height - 10)
        PasswordTextField.center.x = passwordContainerView.frame.size.width/2
        PasswordTextField.center.y = passwordContainerView.frame.size.height/2
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.textColor = .purple
        PasswordTextField.tintColor = .purple
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo])
        PasswordTextField.font = UIFont(name: "Poppins", size: 16)
        passwordContainerView.addSubview(PasswordTextField)
        
        emailContainerView.frame = passwordContainerView.frame
        emailContainerView.center.y = containerView.frame.size.height/3.7
        emailContainerView.center.x = containerView.frame.size.width/2
        emailContainerView.backgroundColor = .white
        emailContainerView.layer.cornerRadius = 25
        containerView.addSubview(emailContainerView)
        
        EmailTextField.frame = CGRect(x: 0, y: 0, width: emailContainerView.frame.size.width - 30, height: emailContainerView.frame.size.height - 10)
        EmailTextField.center.x = emailContainerView.frame.size.width/2
        EmailTextField.center.y = emailContainerView.frame.size.height/2
        EmailTextField.isSecureTextEntry = false
        EmailTextField.textContentType = .emailAddress
        EmailTextField.autocapitalizationType = .none
        EmailTextField.textColor = .purple
        EmailTextField.tintColor = .purple
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo])
        EmailTextField.font = UIFont(name: "Poppins", size: 16)
        emailContainerView.addSubview(EmailTextField)
        //setup the label
        ErrorLabel.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width/1.5, height: 30)
        ErrorLabel.center.x = containerView.frame.size.width/2
        ErrorLabel.center.y = containerView.frame.size.height/10
        ErrorLabel.textColor = .purple
        ErrorLabel.textAlignment = .center
        ErrorLabel.font = UIFont(name: "Poppins", size: 10)
        containerView.addSubview(ErrorLabel)
        
        
        
        //setup the background color of the main view or addimages to the view
        RegisterButton.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width - 60, height: 50)
        RegisterButton.center.x = self.view.frame.size.width/2
        RegisterButton.center.y = self.view.frame.size.height/1.1
        RegisterButton.backgroundColor = .clear
        RegisterButton.layer.cornerRadius = 25
        RegisterButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        RegisterButton.setTitleColor(.white, for: .normal)
        RegisterButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        RegisterButton.setTitle("Create Account", for: .normal)
        
        
        
        questionMarkButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        questionMarkButton.center.x = containerView.frame.size.width - 20
        questionMarkButton.center.y = containerView.frame.size.height - 20
        questionMarkButton.backgroundColor = .systemPurple
        questionMarkButton.layer.cornerRadius = 5
        questionMarkButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 8)
        questionMarkButton.setTitleColor(.white, for: .normal)
        questionMarkButton.setTitle("?", for: .normal)
        questionMarkButton.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
        containerView.addSubview(questionMarkButton)
        
        
 
        self.view.addSubview(RegisterButton)
        self.view.addSubview(containerView)
        self.view.sendSubviewToBack(containerView)
        self.view.sendSubviewToBack(logoView)
        self.view.sendSubviewToBack(RegisterButton)

        
    }
    
    //selector functions
    @objc func showForgotPassword() {
        forgotPasswordView.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height/4)
        forgotPasswordView.center.x = self.view.frame.size.width/2
        forgotPasswordView.center.y = self.view.frame.size.height/5
        forgotPasswordView.backgroundColor = .white
        forgotPasswordView.layer.cornerRadius = 25
        forgotPasswordView.layer.shadowColor = UIColor.black.cgColor
        forgotPasswordView.layer.shadowOffset = CGSize(width: 0, height: 0)
        forgotPasswordView.layer.cornerRadius = 30
        forgotPasswordView.layer.shadowRadius = 8
        forgotPasswordView.layer.shadowOpacity = 0.33
        
        backGroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backGroundView.center.y = self.view.frame.size.height/2
        backGroundView.center.x = self.view.frame.size.width/2
        backGroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.removeView))
        backGroundView.addGestureRecognizer(gesture)
        
        forgotPasswordButton.frame = CGRect(x: 0, y: 0, width: forgotPasswordView.frame.size.width / 1.5, height: forgotPasswordView.frame.size.height / 1.5)
        forgotPasswordButton.center.x = forgotPasswordView.frame.size.width/2
        forgotPasswordButton.center.y = forgotPasswordView.frame.size.height/2
        forgotPasswordButton.backgroundColor = .systemPurple
        forgotPasswordButton.layer.cornerRadius = forgotPasswordButton.frame.size.height/2
        forgotPasswordButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 13)
        forgotPasswordButton.setTitleColor(.white, for: .normal)
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(ForgotPassword), for: .touchUpInside)
        
        self.forgotPasswordView.addSubview(forgotPasswordButton)
        backGroundView.addSubview(forgotPasswordView)
        self.view.addSubview(backGroundView)
        
        
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
    @objc func LoginAction() {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        login()
    }
    
    @objc func registerAction() {
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_1RegisterSeque, sender: self)
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
    
    @objc func removeView() {
        self.forgotPasswordView.removeFromSuperview()
        self.backGroundView.removeFromSuperview()
    }
    
    @objc func ForgotPassword() {
        
      self.forgotPasswordView.removeFromSuperview()
             self.backGroundView.removeFromSuperview()
        
        if let text = self.EmailTextField.text, text.isEmpty {
            self.resetButtonWithNoEmailPopup(title: "Input your email address in the 'Email' Text Field, then click this button again!", message: nil)
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
//                always return case value to false
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


