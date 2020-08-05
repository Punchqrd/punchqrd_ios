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
    
    //MARK:- Variable,Object,Constant Declarations
    let newView = UIView()
    let animationView = AnimationView()
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    
    //Outlet Declarations
    var containerView = UIView()
    var firstLoginButton = UIButton()
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
    
    
    var containerCenterXAnchor = NSLayoutConstraint()
    var forgotPasswordCenterXAnchor = NSLayoutConstraint()
    var isLoginShowing = false
    
    
    
    
    //UserDefaults setup.
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    
    //MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()

        
        
        setupToHideKeyboardOnTapOnView()
        self.PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password:",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.EmailTextField.keyboardType = .emailAddress
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
        
        //right swipe to dismiss the login
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissLoginView))
        dismissGesture.direction = .right
        self.view.addGestureRecognizer(dismissGesture)
        
        //left swipe to view the login
        let viewLoginGesture = UISwipeGestureRecognizer(target: self, action: #selector(setupView))
        viewLoginGesture.direction = .left
        self.view.addGestureRecognizer(viewLoginGesture)
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        containerCenterXAnchor.constant =  self.view.frame.size.width/2 + 70
        forgotPasswordCenterXAnchor.constant = self.view.frame.size.width/2 + 70
        self.PasswordTextField.isHidden = true
        self.EmailTextField.isHidden = true
        isLoginShowing = false


    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
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
        self.navigationController?.navigationBar.isHidden = true
        PasswordTextField.text = nil
        EmailTextField.text = nil
        ErrorLabel.text = nil
        self.removeLoadingView()
        //        setupView()
        
    }
    
    //MARK:- SETUP THE VIEW HERE
    func basicSetup() {
        //register button setup
        self.view.addSubview(RegisterButton)
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        RegisterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        RegisterButton.backgroundColor = .clear
        RegisterButton.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 15)
        RegisterButton.setTitleColor(.black, for: .normal)
        RegisterButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        RegisterButton.setTitle("Create Account", for: .normal)
        
        //login button setup
        self.view.addSubview(firstLoginButton)
        firstLoginButton.translatesAutoresizingMaskIntoConstraints = false
        firstLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        firstLoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        firstLoginButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2).isActive = true
        firstLoginButton.bottomAnchor.constraint(equalTo: RegisterButton.topAnchor, constant: -20).isActive = true
        firstLoginButton.backgroundColor = .clear
        firstLoginButton.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        firstLoginButton.setTitleColor(.black, for: .normal)
        firstLoginButton.setTitle("Login", for: .normal)
        firstLoginButton.addTarget(self, action: #selector(setupView), for: .touchUpInside)
        
        
        //logo setup
        self.view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        //350
        logoView.widthAnchor.constraint(equalToConstant: 520).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 520).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        logoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/2.5).isActive = true
        
        let imageName = "Home Screen Icon"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        logoView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: logoView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: logoView.heightAnchor).isActive = true
        
        
        
        
        
        //container view
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.cornerRadius = 80
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.33
        containerView.backgroundColor = .black
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        containerCenterXAnchor = containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.size.width/2 + 70)
        containerCenterXAnchor.isActive = true
//        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 220).isActive = true
        
        self.view.addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        forgotPasswordCenterXAnchor = forgotPasswordButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0)
        forgotPasswordCenterXAnchor.isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: +20).isActive = true
        forgotPasswordButton.backgroundColor = .clear
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor.lightGray.withAlphaComponent(0.6), for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 11)
        forgotPasswordButton.addTarget(self, action: #selector(ForgotPassword), for: .touchUpInside)
        self.view.bringSubviewToFront(forgotPasswordButton)
        
        //login button
        containerView.addSubview(LoginButton)
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        LoginButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        LoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        LoginButton.bottomAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: -20).isActive = true
        LoginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true

        LoginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        LoginButton.backgroundColor = .clear
        LoginButton.setTitle("Login", for: .normal)
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        LoginButton.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        
        //email textfield
        containerView.addSubview(PasswordTextField)
        PasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        PasswordTextField.bottomAnchor.constraint(equalTo: LoginButton.topAnchor, constant: -10).isActive = true
        PasswordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        PasswordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 40).isActive = true
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.textColor = .white
        PasswordTextField.tintColor = .white
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password:",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.font = UIFont(name: "Poppins-Light", size: 13)
        PasswordTextField.isHidden = true
        
        
        containerView.addSubview(EmailTextField)
        EmailTextField.translatesAutoresizingMaskIntoConstraints = false
        EmailTextField.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: -10).isActive = true
        EmailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        EmailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 40).isActive = true
        EmailTextField.textColor = .white
        EmailTextField.tintColor = .white
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email:",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        EmailTextField.font = UIFont(name: "Poppins-Light", size: 13)
        EmailTextField.isHidden = true
        EmailTextField.textContentType = .emailAddress
        EmailTextField.autocapitalizationType = .none
        
        
    }
    
   
    
    //MARK:- FORGOT PASSWORD FUNCTION
    @objc func showForgotPassword() {
        forgotPasswordView.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height/4)
        forgotPasswordView.center.x = self.view.frame.size.width/2
        forgotPasswordView.center.y = self.view.frame.size.height/1.3
        forgotPasswordView.backgroundColor = .clear
        forgotPasswordView.layer.cornerRadius = 25
        forgotPasswordView.layer.shadowColor = UIColor.black.cgColor
        forgotPasswordView.layer.shadowOffset = CGSize(width: 0, height: 0)
        forgotPasswordView.layer.cornerRadius = 30
        forgotPasswordView.layer.shadowRadius = 8
        forgotPasswordView.layer.shadowOpacity = 0.33
        
        backGroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backGroundView.center.y = self.view.frame.size.height/2
        backGroundView.center.x = self.view.frame.size.width/2
        backGroundView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
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
    
    //setup the login view
    @objc func dismissLoginView() {
        if self.isLoginShowing == true {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .curveEaseOut, animations: {
            self.containerView.center.x = self.view.frame.size.width/2 + self.view.frame.size.width/2 + 70
            self.forgotPasswordButton.center.x = self.view.frame.size.width/2 + self.view.frame.size.width/2 + 70
            self.PasswordTextField.isHidden = true
            self.EmailTextField.isHidden = true

           
        }, completion: { complete in
            self.containerCenterXAnchor.constant = self.view.frame.size.width/2 + 70
            self.forgotPasswordCenterXAnchor.constant = self.view.frame.size.width/2 + 70
            self.isLoginShowing = false
        })
    }
    }
    
    
    @objc func setupView() {
              

              UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .curveEaseOut, animations: {
               
                  self.containerView.center.x = self.view.frame.size.width/2
                  self.forgotPasswordButton.center.x = self.view.frame.size.width/2
                  self.PasswordTextField.isHidden = false
                  self.EmailTextField.isHidden = false

              
                  
                  

                  
              }, completion: { complete in
                    self.containerCenterXAnchor.constant = 0
                    self.forgotPasswordCenterXAnchor.constant = 0
                    //bool value being set to true to indicate that the login view is now showing
                    self.isLoginShowing = true
                
              })
              
              
        
              
              
              
    }
    
    
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
    
    @objc func removeView() {
        self.forgotPasswordView.removeFromSuperview()
        self.backGroundView.removeFromSuperview()
    }
    
    @objc func ForgotPassword() {
        
        self.forgotPasswordView.removeFromSuperview()
        self.backGroundView.removeFromSuperview()
        
        if let text = self.EmailTextField.text, text.isEmpty {
            self.resetButtonWithNoEmailPopup(title: "Input your email address in the 'Email' Text Field, then click the login button again.", message: nil)
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
            
            if error != nil {
                self.removeLoadingView()
                let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (alert: UIAlertAction) in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                
                
                
                //MARK:- UNCOMMENT THIS FOR EMAIL VERIFICATION
                //                let user = Auth.auth().currentUser
                //                switch user!.isEmailVerified {
                //
                //                case true:
                
                
                
                
                
                
                
                
                
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
                
                
                
                
                //                case false:
                //                    self.removeLoadingView()
                //                    self.verifyEmailAlert(title: "Psst", message: "Verify your account before logging in", currentuser : user!)
                //                }
                
                //MARK:- END MARK
                
                
                
                
                
                
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


