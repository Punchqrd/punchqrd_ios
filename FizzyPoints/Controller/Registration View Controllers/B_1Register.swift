//
//  B_1Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie


//this is the CUSTOMER view controller register class
class B_1Register : UIViewController {
    
    
    let newView = UIView()
    let homeAnimation = AnimationView()
    //Constants, Variables, and Object Declaration
    let animationView = AnimationView()
    let db = Firestore.firestore()
    
    //setup the bottom view
    let bottomView = UIView()
    let toggleButton = UIButton()
    let businessRegisterButton = UIButton()
    let employeeRegisterButton = UIButton()
    var toggleVariable = false
    
    //setup the main view.
    let containerView = UIView()
    
    
    let RegisterButton = UIButton()
    //name fields and views
    let FirstName = UITextField()
    let firstNameTextFieldView = UIView()
    
    let LastName = UITextField()
    let lastNameTextFieldView = UIView()
    //email.
    let EmailTextField = UITextField()
    let emailTextFieldView = UIView()
    //password fields and views
    let PasswordTextField = UITextField()
    let passwordTextFieldView = UIView()
    //confirm password fields and views
    let ConfirmPasswordTextField = UITextField()
    let confirmpasswordTextFieldView = UIView()
    
    //birth date input and views
    let birthMonth = SDCTextField()
    let birthMonthView = UIView()
    
    let birthDay = SDCTextField()
    let birthDayView = UIView()
    
    let birthYear = SDCTextField()
    let birthYearView = UIView()
    
    let cakeImage = UIImage(named: "birthday")
    
    
    //labels
    let ErrorLabel = UILabel()
    //setup gender images in this array
    
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationController?.navigationBar.shadowImage = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).as4ptImage()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
       navigationItem.title = "Create an Account"
      
        setupToHideKeyboardOnTapOnView()
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        self.FirstName.delegate = self
        self.LastName.delegate = self
        self.birthYear.delegate = self
        self.birthYear.maxLength = 4
        self.birthDay.delegate = self
        self.birthDay.maxLength = 2
        self.birthMonth.delegate = self
        self.birthMonth.maxLength = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //want to setup the toggle button and bottom view below
        setupToggleView()
        setupToggleButton()
        setupMainView()
    }
    
    
    //MARK:- Aesthetic functions
    
    
    func setupMainView() {
        self.view.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 50, height: self.view.frame.size.height / 2)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 50).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 2).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: containerView.frame.size.height/1.3).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.backgroundColor = .white
        self.view.sendSubviewToBack(containerView)
        
        //setup the button
        RegisterButton.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width - 60, height: containerView.frame.size.height/9)
        RegisterButton.center.x = self.view.center.x - 23
        RegisterButton.center.y = self.containerView.frame.size.height - (self.RegisterButton.frame.size.height + 10)
        RegisterButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        RegisterButton.setTitleColor(.white, for: .normal)
        RegisterButton.setTitle("Done", for: .normal)
        RegisterButton.backgroundColor = .black
        GlobalFunctions.setButtonRadius(button: RegisterButton)
        RegisterButton.layer.cornerRadius = RegisterButton.frame.height/2.1
        RegisterButton.addTarget(self, action: #selector(confirmData), for: .touchUpInside)
        self.containerView.addSubview(RegisterButton)
        
        
        
        
        
        
        
        //setup the confirmPAssword textfield and view
        confirmpasswordTextFieldView.frame = RegisterButton.frame
        confirmpasswordTextFieldView.backgroundColor = .white
        confirmpasswordTextFieldView.center.x = self.view.center.x - 23
        confirmpasswordTextFieldView.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*2 + 20)
//        B_1Register.setupShadow(view: confirmpasswordTextFieldView)
        
        
        ConfirmPasswordTextField.frame = CGRect(x: 0, y: 0, width: confirmpasswordTextFieldView.frame.size.width - 30, height: confirmpasswordTextFieldView.frame.size.height - 10)
        ConfirmPasswordTextField.placeholder = "Confirm Password"
        ConfirmPasswordTextField.font =  UIFont(name: "Poppins", size: 15)
        ConfirmPasswordTextField.center = confirmpasswordTextFieldView.center
        ConfirmPasswordTextField.isSecureTextEntry = true
        containerView.addSubview(ConfirmPasswordTextField)
        self.containerView.addSubview(confirmpasswordTextFieldView)
        self.containerView.sendSubviewToBack(confirmpasswordTextFieldView)
        
        
        
        
        
        //setup the password text field and view
        passwordTextFieldView.frame = RegisterButton.frame
        passwordTextFieldView.backgroundColor = .white
        passwordTextFieldView.center.x = self.view.center.x - 23
        passwordTextFieldView.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*3 + 30)
//        B_1Register.setupShadow(view: passwordTextFieldView)
        
        
        PasswordTextField.frame = CGRect(x: 0, y: 0, width: confirmpasswordTextFieldView.frame.size.width - 30, height: confirmpasswordTextFieldView.frame.size.height - 10)
        PasswordTextField.placeholder = "Password"
        PasswordTextField.font =  UIFont(name: "Poppins", size: 15)
        PasswordTextField.center = passwordTextFieldView.center
        PasswordTextField.isSecureTextEntry = true
        containerView.addSubview(PasswordTextField)
        containerView.addSubview(passwordTextFieldView)
        containerView.sendSubviewToBack(passwordTextFieldView)
        
        
        
        
        //setup the date containers and textfields
        //setup the image of the cake next to the textfields
        let cakeView = UIImageView(image: nil)
        cakeView.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.height, height: RegisterButton.frame.size.height)
        containerView.addSubview(cakeView)
        //        cakeView.center.x = cakeView.frame.size.width*1.5
        cakeView.translatesAutoresizingMaskIntoConstraints = false
        cakeView.widthAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        cakeView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        cakeView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*4 + 40)).isActive = true
        cakeView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -(containerView.frame.size.width - RegisterButton.frame.size.width)/2).isActive = true
//        B_1Register.setupShadow(view: cakeView)
        
        
        
        //year
        birthYearView.translatesAutoresizingMaskIntoConstraints = false
        birthYearView.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.width/2.5, height: RegisterButton.frame.size.height)
        containerView.addSubview(birthYearView)
        birthYearView.widthAnchor.constraint(equalToConstant: RegisterButton.frame.size.width/2.5).isActive = true
        birthYearView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        birthYearView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*4 + 40)).isActive = true
        birthYearView.rightAnchor.constraint(equalTo: cakeView.leftAnchor, constant: -5).isActive = true
        birthYearView.backgroundColor = .white
//        B_1Register.setupShadow(view: birthYearView)
        
        
        birthYear.frame = CGRect(x: 0, y: 0, width: birthYearView.frame.size.width - 30, height: birthYearView.frame.size.height - 10)
        birthYear.placeholder = "YYYY"
        birthYear.center = birthYearView.center
        
        birthYear.textAlignment = .center
        birthYear.keyboardType = .numberPad
        
        birthYearView.addSubview(birthYear)
        containerView.sendSubviewToBack(birthYearView)
        
        //day
        birthDayView.translatesAutoresizingMaskIntoConstraints = false
        birthDayView.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.width/5, height: RegisterButton.frame.size.height)
        containerView.addSubview(birthDayView)
        birthDayView.widthAnchor.constraint(equalToConstant: RegisterButton.frame.size.width/5).isActive = true
        birthDayView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        birthDayView.rightAnchor.constraint(equalTo: birthYearView.leftAnchor, constant: -5).isActive = true
        birthDayView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*4 + 40)).isActive = true
        birthDayView.backgroundColor = .white
//        B_1Register.setupShadow(view: birthDayView)
        
        
        birthDay.frame = CGRect(x: 0, y: 0, width: birthDayView.frame.size.width - 20, height: birthDayView.frame.size.height - 10)
        birthDay.placeholder = "DD"
        birthDay.center = birthDayView.center
        birthDay.textAlignment = .center
        birthDay.keyboardType = .numberPad
        
        birthDayView.addSubview(birthDay)
        containerView.sendSubviewToBack(birthDayView)
        
        //month
        birthMonthView.translatesAutoresizingMaskIntoConstraints = false
        birthMonthView.frame = CGRect(x: 0, y: 0, width: (RegisterButton.frame.size.width - cakeView.frame.size.width - birthYearView.frame.size.width), height: RegisterButton.frame.size.height)
        containerView.addSubview(birthMonthView)
        birthMonthView.widthAnchor.constraint(equalToConstant: (RegisterButton.frame.size.width - cakeView.frame.size.width - birthYearView.frame.size.width)).isActive = true
        birthMonthView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        birthMonthView.rightAnchor.constraint(equalTo: birthDayView.leftAnchor, constant: -5).isActive = true
        birthMonthView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: (containerView.frame.size.width - RegisterButton.frame.size.width)/2).isActive = true
        birthMonthView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*4 + 40)).isActive = true
        birthMonthView.backgroundColor = .white
//        B_1Register.setupShadow(view: birthMonthView)
        
        
        birthMonth.translatesAutoresizingMaskIntoConstraints = false
        birthMonth.frame = CGRect(x: 0, y: 0, width: (RegisterButton.frame.size.width - cakeView.frame.size.width - birthYearView.frame.size.width), height: birthMonthView.frame.size.height - 10)
        birthMonthView.addSubview(birthMonth)
        birthMonth.centerXAnchor.constraint(equalTo: birthMonthView.centerXAnchor, constant: 0).isActive = true
        birthMonth.centerYAnchor.constraint(equalTo: birthMonthView.centerYAnchor, constant: 0).isActive = true
        birthMonth.placeholder = "MM"
        birthMonth.textAlignment = .center
        birthMonth.keyboardType = .numberPad
        
        containerView.sendSubviewToBack(birthMonthView)
        
        
        
        
        //setup the email field
        emailTextFieldView.frame = RegisterButton.frame
        emailTextFieldView.backgroundColor = .white
        emailTextFieldView.center.x = self.view.center.x - 23
        emailTextFieldView.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*5 + 50)
//        B_1Register.setupShadow(view: emailTextFieldView)
        
        
        EmailTextField.frame = CGRect(x: 0, y: 0, width: emailTextFieldView.frame.size.width - 30, height: emailTextFieldView.frame.size.height - 10)
        EmailTextField.placeholder = "Email"
        EmailTextField.center = emailTextFieldView.center
        EmailTextField.font =  UIFont(name: "Poppins", size: 15)
        EmailTextField.textContentType = .emailAddress
        EmailTextField.autocapitalizationType = .none
        containerView.addSubview(EmailTextField)
        containerView.addSubview(emailTextFieldView)
        containerView.sendSubviewToBack(emailTextFieldView)
        
        //setup the full name field
        firstNameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextFieldView.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.width/2.1, height: RegisterButton.frame.size.height)
        containerView.addSubview(firstNameTextFieldView)
        firstNameTextFieldView.widthAnchor.constraint(equalToConstant: RegisterButton.frame.size.width/2.1).isActive = true
        firstNameTextFieldView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        firstNameTextFieldView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: (containerView.frame.size.width - RegisterButton.frame.size.width)/2).isActive = true
        firstNameTextFieldView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: (self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*6 + 60))).isActive = true
        firstNameTextFieldView.backgroundColor = .white
//        B_1Register.setupShadow(view: firstNameTextFieldView)
        
        
        FirstName.frame = CGRect(x: 0, y: 0, width: firstNameTextFieldView.frame.size.width - 30, height: firstNameTextFieldView.frame.size.height - 10)
        FirstName.placeholder = "First Name"
        FirstName.center = firstNameTextFieldView.center
        FirstName.font =  UIFont(name: "Poppins", size: 15)
        firstNameTextFieldView.addSubview(FirstName)
        containerView.sendSubviewToBack(firstNameTextFieldView)
        
        //last name
        lastNameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextFieldView.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.width/2.1, height: RegisterButton.frame.size.height)
        containerView.addSubview(lastNameTextFieldView)
        lastNameTextFieldView.widthAnchor.constraint(equalToConstant: RegisterButton.frame.size.width/2.1).isActive = true
        lastNameTextFieldView.heightAnchor.constraint(equalToConstant: RegisterButton.frame.size.height).isActive = true
        lastNameTextFieldView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -(containerView.frame.size.width - RegisterButton.frame.size.width)/2).isActive = true
        lastNameTextFieldView.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: (self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*6 + 60))).isActive = true
        lastNameTextFieldView.backgroundColor = .white
        //        firstNameTextFieldView.center.x = self.view.center.x - 23
//        B_1Register.setupShadow(view: lastNameTextFieldView)
        
        LastName.frame = CGRect(x: 0, y: 0, width: lastNameTextFieldView.frame.size.width - 30, height: lastNameTextFieldView.frame.size.height - 10)
        LastName.placeholder = "Last Name"
        LastName.center = firstNameTextFieldView.center
        LastName.font =  UIFont(name: "Poppins", size: 15)
        lastNameTextFieldView.addSubview(LastName)
        containerView.sendSubviewToBack(lastNameTextFieldView)
        
        
        
        
        
        
        //setup the error label
        ErrorLabel.frame = CGRect(x: 0, y: 0, width: RegisterButton.frame.size.width, height: RegisterButton.frame.size.height/1.5)
        ErrorLabel.text = "Customer"
        ErrorLabel.textColor = .black
        ErrorLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        ErrorLabel.textAlignment = .left
        ErrorLabel.center.x = self.view.center.x - 23
        ErrorLabel.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*7 + 70)
        ErrorLabel.numberOfLines = 0
        containerView.addSubview(ErrorLabel)
        
        
        
        
        
        
        
        
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            //animate all of the containerviews elements to animate with it
            self.containerView.center.y = self.view.center.y - self.containerView.frame.size.height / 4
            
        }, completion: nil)
        
        //  GlobalFunctions.setButtonRadius(button: self.RegisterButton)
        
        
    }
    
    static func setupShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = view.frame.height/2.1
    }
    
    func addLoadingView() {
        self.setupAnimation()
    }
    
    //this can stay
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
    
    //this can stay
    func removeLoadingView() {
        self.animationView.stop()
        self.animationView.removeFromSuperview()
        
    }
    
    
    //MARK:- Actions and Data Setup
    @objc func confirmData() {
        //the next 3 instantiations set the global variables to be used in the final dictionary as what the user inputted in the text fields.
        self.view.endEditing(true)
        if let text = self.ConfirmPasswordTextField.text, !text.isEmpty
        {
            if let text = self.PasswordTextField.text, !text.isEmpty{
                if let text = self.birthYear.text, !text.isEmpty {
                    if let text = self.birthDay.text, !text.isEmpty {
                        if let text = self.birthMonth.text, !text.isEmpty {
                            if let text = self.FirstName.text, !text.isEmpty {
                                if let text = self.LastName.text, !text.isEmpty {
                                    if let text = self.EmailTextField.text, !text.isEmpty {
                                        
                                        
                                        if self.ConfirmPasswordTextField.text! == self.PasswordTextField.text! {
                                            GlobalVariables.ActualIDs.ActualName = "\(String(describing: FirstName.text!)) \(LastName.text!)"
                                            GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
                                            GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
                                            GlobalVariables.ActualIDs.ActualMonth = Int(birthMonth.text!)
                                            GlobalVariables.ActualIDs.ActualDay = Int(birthDay.text!)
                                            GlobalVariables.ActualIDs.ActualYear = Int(birthYear.text!)
                                            ///add full name as a result of first and last name.
                                            
                                            
                                            //add more of the inputs to the this field must first create new global variables
                                            
                                            SetupNewUser()
                                            
                                            
                                        } else {
                                            self.ErrorLabel.text = "Make sure both passwords are the same."
                                        }
                                        
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
            
            
        else {
            self.ErrorLabel.text = "Oops something's missing."
        }
        
    }
    
    
    //returns a new list with the customer variables
    func InstantiateCustomerList() -> [String : Any] {
        //this is the new list that will be created.
        let NewUser = [
            GlobalVariables.UserIDs.UserName : GlobalVariables.ActualIDs.ActualName!, //(1) get rid of this and split into two
            GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail!,
            GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword!,
            GlobalVariables.UserIDs.UserBirthMonth: GlobalVariables.ActualIDs.ActualMonth!,
            GlobalVariables.UserIDs.UserBirthDay: GlobalVariables.ActualIDs.ActualDay!,
            GlobalVariables.UserIDs.UserBirthYear: GlobalVariables.ActualIDs.ActualYear!,
            GlobalVariables.UserIDs.UserType: "Customer",
            GlobalVariables.UserIDs.UserCodeString : "",
            //need to add a first name and last name field instead of a full name field. (2) create two fields.
            
            
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
        self.addLoadingView()
        
        Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
            
            if let error = error {
                self.removeLoadingView()
                self.ErrorLabel.text = (error.localizedDescription)
                
            }
            else {
                print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a Customer")
                self.SetupFirebaseData()
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
    
    func setupToggleView() {
        bottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/4)
        bottomView.center.x = self.view.center.x
        bottomView.center.y = self.view.frame.height + bottomView.frame.size.height/2
        bottomView.backgroundColor = UIColor.systemPurple.withAlphaComponent(1)
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomView.layer.shadowRadius = 8
        bottomView.layer.shadowOpacity = 0.33
        bottomView.layer.cornerRadius = 20
        
        employeeRegisterButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 50)
        employeeRegisterButton.backgroundColor = .white
        employeeRegisterButton.center.x = self.bottomView.center.x - self.bottomView.center.x/2.5
        employeeRegisterButton.center.y = self.bottomView.center.y
        GlobalFunctions.setButtonRadius(button: employeeRegisterButton)
        employeeRegisterButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        employeeRegisterButton.setTitleColor(.purple, for: .normal)
        employeeRegisterButton.setTitle("New Employee", for: .normal)
        employeeRegisterButton.addTarget(self, action: #selector(toEmployeeView), for: .touchUpInside)
        
        
        businessRegisterButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 50)
        businessRegisterButton.backgroundColor = .white
        businessRegisterButton.center.x = self.bottomView.center.x + self.bottomView.center.x/2.5
        businessRegisterButton.center.y = self.bottomView.center.y
        GlobalFunctions.setButtonRadius(button: businessRegisterButton)
        businessRegisterButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        businessRegisterButton.setTitleColor(.purple, for: .normal)
        businessRegisterButton.setTitle("New Owner", for: .normal)
        businessRegisterButton.addTarget(self, action: #selector(toOwnerView), for: .touchUpInside)
        
        self.view.addSubview(employeeRegisterButton)
        self.view.addSubview(businessRegisterButton)
        
        self.view.addSubview(bottomView)
        self.view.sendSubviewToBack(bottomView)
        
        
        
    }
    
    func setupToggleButton() {
        
        let backGroundImage = UIImage(systemName: "chevron.down")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        self.toggleVariable = true
        self.toggleButton.frame = CGRect(x: 0, y: 0, width: 25, height: 15)
        self.toggleButton.center.x = self.view.center.x
        self.toggleButton.center.y = self.view.center.y + self.view.center.y/1.3
        self.toggleButton.setBackgroundImage(tintedImage, for: .normal)
        self.toggleButton.tintColor = .black
        self.toggleButton.addTarget(self, action: #selector(showToggleView), for: .touchUpInside)
        self.view.addSubview(toggleButton)
    }
    
    
    //MARK:- @objc functions called
    
    @objc func toEmployeeView() {
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserEmployee
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_2RegisterSeque, sender: self)
    }
    
    @objc func toOwnerView() {
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserOwner
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_1RegisterSeque, sender: self)
    }
    
    @objc func showToggleView() {
        if self.toggleVariable == true {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                
                self.toggleButton.center.y = self.view.center.y + self.bottomView.frame.size.height/1.3
                self.toggleButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.bottomView.center.y = self.view.frame.height - self.bottomView.frame.size.height/2
                self.employeeRegisterButton.center.y = self.bottomView.center.y
                self.businessRegisterButton.center.y = self.bottomView.center.y
                self.toggleVariable = false
                
            }, completion: nil)
        } else if self.toggleVariable ==  false {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.toggleButton.center.y = self.view.center.y + self.view.center.y/1.5
                self.toggleButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
                self.bottomView.center.y = self.view.frame.height + self.bottomView.frame.size.height/2
                self.employeeRegisterButton.center.y = self.bottomView.center.y
                self.businessRegisterButton.center.y = self.bottomView.center.y
                self.toggleVariable = true
                
            }, completion: nil)
        }
    }
    
    
    
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}


extension B_1Register: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Verify all the conditions
        if let sdcTextField = textField as? SDCTextField {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return true
        }
    }
}


