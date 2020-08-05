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
        
        let verticalSeperatorConstraint = -40.0
        let widthAnchor = self.view.frame.size.width - 50
        let registerButtonHeight = 50
        
        
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 2).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        
        
        //setup the button
        self.containerView.addSubview(RegisterButton)
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: CGFloat(registerButtonHeight)).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: widthAnchor - 10).isActive = true
        RegisterButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        RegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        RegisterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        RegisterButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        RegisterButton.setTitleColor(.black, for: .normal)
        RegisterButton.setTitle("Done", for: .normal)
        RegisterButton.setTitleColor(.white, for: .normal)
        RegisterButton.backgroundColor = .black
        RegisterButton.layer.cornerRadius = 5
        RegisterButton.addTarget(self, action: #selector(confirmData), for: .touchUpInside)
        
        
        
        


        containerView.addSubview(ConfirmPasswordTextField)
        ConfirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        ConfirmPasswordTextField.bottomAnchor.constraint(equalTo: RegisterButton.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        ConfirmPasswordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        ConfirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.6)])
        ConfirmPasswordTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        ConfirmPasswordTextField.adjustsFontSizeToFitWidth = true
        ConfirmPasswordTextField.textColor = .black
        ConfirmPasswordTextField.isSecureTextEntry = true
//


//
        containerView.addSubview(PasswordTextField)
        PasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        PasswordTextField.bottomAnchor.constraint(equalTo: ConfirmPasswordTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        PasswordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        PasswordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        PasswordTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        PasswordTextField.adjustsFontSizeToFitWidth = true
        PasswordTextField.textColor = .black
        PasswordTextField.isSecureTextEntry = true
        
        



        containerView.addSubview(birthYear)
        birthYear.translatesAutoresizingMaskIntoConstraints = false
        birthYear.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        birthYear.widthAnchor.constraint(equalToConstant: 70).isActive = true
        birthYear.attributedPlaceholder = NSAttributedString(string:"YYYY", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthYear.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        birthYear.textAlignment = .left
        birthYear.keyboardType = .numberPad
        birthYear.textColor = .black



        containerView.addSubview(birthDay)
        birthDay.translatesAutoresizingMaskIntoConstraints = false
        birthDay.rightAnchor.constraint(equalTo: birthYear.leftAnchor, constant: 0).isActive = true
        birthYear.leftAnchor.constraint(equalTo: birthDay.rightAnchor, constant: 0).isActive = true
        birthDay.widthAnchor.constraint(equalToConstant: 70).isActive = true
        birthDay.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        birthDay.attributedPlaceholder = NSAttributedString(string:"DD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthDay.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        birthDay.textAlignment = .left
        birthDay.keyboardType = .numberPad
        birthDay.textColor = .black




        containerView.addSubview(birthMonth)
        birthMonth.translatesAutoresizingMaskIntoConstraints = false
        birthMonth.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        birthDay.leftAnchor.constraint(equalTo: birthMonth.rightAnchor, constant: 0).isActive = true
        birthMonth.widthAnchor.constraint(equalToConstant: 70).isActive = true
        birthMonth.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        birthMonth.attributedPlaceholder = NSAttributedString(string:"MM", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthMonth.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        birthMonth.textAlignment = .left
        birthMonth.keyboardType = .numberPad
        birthMonth.textColor = .black





        //setup the email field
        containerView.addSubview(EmailTextField)
        EmailTextField.translatesAutoresizingMaskIntoConstraints = false
        EmailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        EmailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        EmailTextField.bottomAnchor.constraint(equalTo: birthMonth.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        EmailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        EmailTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        EmailTextField.textColor = .black
        EmailTextField.textContentType = .emailAddress
        EmailTextField.autocapitalizationType = .none
        



        containerView.addSubview(FirstName)
        FirstName.translatesAutoresizingMaskIntoConstraints = false
        FirstName.bottomAnchor.constraint(equalTo: EmailTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        FirstName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        FirstName.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        FirstName.attributedPlaceholder = NSAttributedString(string:"First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        FirstName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        FirstName.textColor = .black
        FirstName.autocapitalizationType = .words
        FirstName.textAlignment = .left


        containerView.addSubview(LastName)
        LastName.translatesAutoresizingMaskIntoConstraints = false
        LastName.bottomAnchor.constraint(equalTo: EmailTextField.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        LastName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        FirstName.leftAnchor.constraint(equalTo: LastName.rightAnchor, constant: 0).isActive = true
        LastName.rightAnchor.constraint(equalTo: FirstName.leftAnchor, constant: 0).isActive = true
        LastName.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
         //need left anchor.
        LastName.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        LastName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        LastName.textColor = .black
        LastName.autocapitalizationType = .words
        LastName.textAlignment = .left


        //setup the error label
        containerView.addSubview(ErrorLabel)
        ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        ErrorLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        ErrorLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        ErrorLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ErrorLabel.bottomAnchor.constraint(equalTo: FirstName.topAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        ErrorLabel.text = ""
        ErrorLabel.textColor = .black
        ErrorLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        ErrorLabel.textAlignment = .center
        ErrorLabel.center.x = self.view.center.x - 23
        ErrorLabel.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*7 + 70)
        ErrorLabel.numberOfLines = 0
        containerView.addSubview(ErrorLabel)






        
        
      
        
        
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
        
        self.animationView.animation = Animation.named(GlobalVariables.animationTitles.mainLoader)
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
                                            let alert = UIAlertController(title: "Make sure both passwords match.", message: nil, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                                                return
                                            }))
                                            self.present(alert, animated: true, completion: nil)
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
            let alert = UIAlertController(title: "Make sure everything's filled out.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                return
            }))
            self.present(alert, animated: true, completion: nil)
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
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action: UIAlertAction) in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                
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
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(1)
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomView.layer.shadowRadius = 8
        bottomView.layer.shadowOpacity = 0.33
        bottomView.layer.cornerRadius = 20
        
        employeeRegisterButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 60)
        employeeRegisterButton.backgroundColor = .clear
        employeeRegisterButton.center.x = self.bottomView.center.x - self.bottomView.center.x/2.5
        employeeRegisterButton.center.y = self.bottomView.center.y
        employeeRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        employeeRegisterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        employeeRegisterButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        employeeRegisterButton.setTitleColor(.white, for: .normal)
        employeeRegisterButton.setTitle("Employee", for: .normal)
        employeeRegisterButton.addTarget(self, action: #selector(toEmployeeView), for: .touchUpInside)
        
        
        businessRegisterButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 60)
        businessRegisterButton.backgroundColor = .clear
        businessRegisterButton.center.x = self.bottomView.center.x + self.bottomView.center.x/2.5
        businessRegisterButton.center.y = self.bottomView.center.y
        businessRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        businessRegisterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        businessRegisterButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        businessRegisterButton.setTitleColor(.white, for: .normal)
        businessRegisterButton.setTitle("Owner", for: .normal)
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
        self.toggleButton.tintColor = .systemPurple
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


