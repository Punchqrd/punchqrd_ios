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
class B_1Register : UIViewController, UITextFieldDelegate {
    
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
    let NameTextField = UITextField()
    let EmailTextField = UITextField()
    
    let PasswordTextField = UITextField()
    let passwordTextFieldView = UIView()
    
    let ConfirmPasswordTextField = UITextField()
    let confirmpasswordTextFieldView = UIView()
    
    let ageInput = UITextField()
    let birthMonth = UITextField()
    let birthDay = UITextField()
    let birthYear = UITextField()
    let ErrorLabel = UILabel()
    let gender = UISegmentedControl()
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        self.NameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //want to setup the toggle button and bottom view below
        setupToggleView()
        setupToggleButton()
        setupMainView()
    }
    
    
    //MARK:- Aesthetic functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupMainView() {
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 50, height: self.view.frame.size.height / 2)
        containerView.center.y = self.view.center.y - self.containerView.frame.size.height
        containerView.center.x = self.view.center.x
        containerView.backgroundColor = .purple
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.cornerRadius = 20
        self.view.addSubview(containerView)
        self.view.sendSubviewToBack(containerView)
        
        //setup the button
        RegisterButton.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width - 60, height: containerView.frame.size.height/9)
        RegisterButton.center.x = self.view.center.x - 23
        RegisterButton.center.y = self.containerView.frame.size.height - (self.RegisterButton.frame.size.height + 10)
        RegisterButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        RegisterButton.setTitleColor(.white, for: .normal)
        RegisterButton.setTitle("Confirm", for: .normal)
        RegisterButton.backgroundColor = .systemGreen
        GlobalFunctions.setButtonRadius(button: RegisterButton)
        RegisterButton.layer.cornerRadius = 20
        //add a target here
        self.containerView.addSubview(RegisterButton)
        
        
        
        
        
        
        
        //setup the confirmPAssword textfield and view
        confirmpasswordTextFieldView.frame = RegisterButton.frame
        confirmpasswordTextFieldView.backgroundColor = .white
        confirmpasswordTextFieldView.center.x = self.view.center.x - 23
        confirmpasswordTextFieldView.center.y = self.containerView.frame.size.height - ((self.RegisterButton.frame.size.height)*2 + 20)
        setupShadow(view: confirmpasswordTextFieldView)
        
        
        ConfirmPasswordTextField.frame = CGRect(x: 0, y: 0, width: confirmpasswordTextFieldView.frame.size.width - 30, height: confirmpasswordTextFieldView.frame.size.height - 10)
        ConfirmPasswordTextField.placeholder = "Confirm Password"
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
        setupShadow(view: passwordTextFieldView)
        
        
        PasswordTextField.frame = CGRect(x: 0, y: 0, width: confirmpasswordTextFieldView.frame.size.width - 30, height: confirmpasswordTextFieldView.frame.size.height - 10)
        PasswordTextField.placeholder = "Password"
        PasswordTextField.center = passwordTextFieldView.center
        PasswordTextField.isSecureTextEntry = true
        containerView.addSubview(PasswordTextField)
        self.containerView.addSubview(passwordTextFieldView)
        self.containerView.sendSubviewToBack(passwordTextFieldView)
      
        
        
        
        
        
        
        
        
        
        
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            //animate all of the containerviews elements to animate with it
            self.containerView.center.y = self.view.center.y - self.containerView.frame.size.height / 4
           
        }, completion: nil)
        
        //  GlobalFunctions.setButtonRadius(button: self.RegisterButton)
        
        
    }
    
    func setupShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = 20
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
            if self.ConfirmPasswordTextField.text! == self.PasswordTextField.text! {
                GlobalVariables.ActualIDs.ActualName = NameTextField.text
                GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
                GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
                //add more of the inputs to the this field must first create new global variables
                
                SetupNewUser()
                
            } else {
                self.ErrorLabel.text = "Make sure both passwords are the same."
            }
            
        } else {
            self.ErrorLabel.text = "Confirm your password"
        }
        
    }
    
    
    //returns a new list with the customer variables
    func InstantiateCustomerList() -> [String : Any] {
        //this is the new list that will be created.
        let NewUser = [
            GlobalVariables.UserIDs.UserName : GlobalVariables.ActualIDs.ActualName!,
            GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail!,
            GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword!,
            GlobalVariables.UserIDs.UserType: "Customer",
            GlobalVariables.UserIDs.UserCodeString : "",
            //add all of the new variables to this array to be added into the database.
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
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_2RegisterSeque, sender: self)
    }
    
    @objc func toOwnerView() {
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
