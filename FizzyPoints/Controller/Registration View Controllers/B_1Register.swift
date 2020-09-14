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
    let animationView = AnimationView()
    let db = Firestore.firestore()
    
    
    let businessRegisterButton = ActionButton(backgroundColor: .black, title: "Business Owner", image: nil)
    let employeeRegisterButton = ActionButton(backgroundColor: .black, title: "Employee", image: nil)
    var toggleVariable = false
    
    //setup the main view.
    
    
    let RegisterButton = ActionButton(backgroundColor: Global_Colors.colors.apricot, title: "Register", image: nil)
    //name fields and views
    let FirstName = UITextField()
    
    let LastName = UITextField()
    //email.
    let EmailTextField = UITextField()
    //password fields and views
    let PasswordTextField = UITextField()
    //confirm password fields and views
    let ConfirmPasswordTextField = UITextField()
    
    //birth date input and views
    let birthMonth = SDCTextField()
    
    let birthDay = SDCTextField()
    
    let birthYear = SDCTextField()
    
    
    
    
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.bounds.width)
        print(view.bounds.height)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.navigationBar.shadowImage = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).as4ptImage()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        navigationItem.title = "Create Your Account"
        //back bar button item reset.
        self.navigationController!.navigationBar.topItem!.title = ""
        
        
        
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
        setupMainView()
        addbottomButtons()
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .white
    }
    
    
    //MARK:- Aesthetic functions
    
    
    func setupMainView() {
        
        let verticalSeperatorConstraint = 20.0
        let rightAnchor = -20
        let leftAnchor = 20
        let registerButtonHeight = 80
        
        
        view.addSubview(LastName)
        LastName.translatesAutoresizingMaskIntoConstraints = false
        LastName.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(100)).isActive = true
        LastName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        
        view.addSubview(FirstName)
        FirstName.translatesAutoresizingMaskIntoConstraints = false
        FirstName.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(100)).isActive = true
        FirstName.leftAnchor.constraint(equalTo: LastName.rightAnchor, constant: CGFloat(leftAnchor)).isActive = true
        FirstName.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2).isActive = true
        FirstName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(rightAnchor)).isActive = true
        LastName.rightAnchor.constraint(equalTo: FirstName.leftAnchor, constant: CGFloat(rightAnchor)).isActive = true
        
        
        view.addSubview(EmailTextField)
        EmailTextField.translatesAutoresizingMaskIntoConstraints = false
        EmailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        EmailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(rightAnchor)).isActive = true
        EmailTextField.topAnchor.constraint(equalTo: LastName.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        
        
        view.addSubview(birthMonth)
        birthMonth.translatesAutoresizingMaskIntoConstraints = false
        birthMonth.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        birthMonth.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        
        
        view.addSubview(birthDay)
        birthDay.translatesAutoresizingMaskIntoConstraints = false
        birthDay.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        birthDay.leftAnchor.constraint(equalTo: birthMonth.rightAnchor, constant: CGFloat(leftAnchor)).isActive = true
        birthMonth.rightAnchor.constraint(equalTo: birthDay.leftAnchor, constant: CGFloat(rightAnchor)).isActive = true
        
        view.addSubview(birthYear)
        birthYear.translatesAutoresizingMaskIntoConstraints = false
        birthYear.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        birthYear.leftAnchor.constraint(equalTo: birthDay.rightAnchor, constant: CGFloat(leftAnchor)).isActive = true
        birthYear.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(rightAnchor)).isActive = true
        
        
        view.addSubview(PasswordTextField)
        PasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        PasswordTextField.topAnchor.constraint(equalTo: birthMonth.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        PasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        PasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(rightAnchor)).isActive = true
        
        view.addSubview(ConfirmPasswordTextField)
        ConfirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        ConfirmPasswordTextField.topAnchor.constraint(equalTo: PasswordTextField.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        ConfirmPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        ConfirmPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(rightAnchor)).isActive = true
        
        
        view.addSubview(RegisterButton)
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.topAnchor.constraint(equalTo: ConfirmPasswordTextField.bottomAnchor, constant: CGFloat(verticalSeperatorConstraint)).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: CGFloat(registerButtonHeight)).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        RegisterButton.addTarget(self, action: #selector(confirmData), for: .touchUpInside)
        
        
        
        
        
        ConfirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.6)])
        ConfirmPasswordTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        ConfirmPasswordTextField.adjustsFontSizeToFitWidth = true
        ConfirmPasswordTextField.textColor = .black
        ConfirmPasswordTextField.isSecureTextEntry = true
        //
        
        
        
        PasswordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        PasswordTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        PasswordTextField.adjustsFontSizeToFitWidth = true
        PasswordTextField.textColor = .black
        PasswordTextField.isSecureTextEntry = true
        
        
        
        
        birthYear.attributedPlaceholder = NSAttributedString(string:"YYYY", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthYear.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        birthYear.textAlignment = .left
        birthYear.keyboardType = .numberPad
        birthYear.textColor = .black
        
        
        
        birthDay.attributedPlaceholder = NSAttributedString(string:"DD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthDay.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        birthDay.textAlignment = .left
        birthDay.keyboardType = .numberPad
        birthDay.textColor = .black
        
        
        
        
        
        birthMonth.attributedPlaceholder = NSAttributedString(string:"MM", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        birthMonth.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        birthMonth.textAlignment = .left
        birthMonth.keyboardType = .numberPad
        birthMonth.textColor = .black
        
        
        
        
        
        
        EmailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        EmailTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        EmailTextField.textColor = .black
        EmailTextField.textContentType = .emailAddress
        EmailTextField.autocapitalizationType = .none
        
        
        
        
        
        FirstName.attributedPlaceholder = NSAttributedString(string:"First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        FirstName.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        FirstName.textColor = .black
        FirstName.autocapitalizationType = .words
        FirstName.textAlignment = .left
        
        
        
        LastName.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)])
        LastName.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        LastName.textColor = .black
        LastName.autocapitalizationType = .words
        LastName.textAlignment = .left
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    func addbottomButtons() {
        let widthAnchor = 300
        
        view.addSubview(employeeRegisterButton)
        employeeRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        employeeRegisterButton.widthAnchor.constraint(equalToConstant: CGFloat(widthAnchor)).isActive = true
        employeeRegisterButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        employeeRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        employeeRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        employeeRegisterButton.addTarget(self, action: #selector(toEmployeeView), for: .touchUpInside)
        
        view.addSubview(businessRegisterButton)
        businessRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        businessRegisterButton.widthAnchor.constraint(equalToConstant: CGFloat(widthAnchor)).isActive = true
        businessRegisterButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        businessRegisterButton.bottomAnchor.constraint(equalTo: employeeRegisterButton.topAnchor, constant: -10).isActive = true
        businessRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        businessRegisterButton.addTarget(self, action: #selector(toOwnerView), for: .touchUpInside)
        
        //        view.addSubview(ownerOrEmployeeLabel)
        //        ownerOrEmployeeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        ownerOrEmployeeLabel.leftAnchor.constraint(equalTo: businessRegisterButton.leftAnchor, constant: 15).isActive = true
        //        ownerOrEmployeeLabel.rightAnchor.constraint(equalTo: businessRegisterButton.rightAnchor, constant: 0).isActive = true
        //        ownerOrEmployeeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //        ownerOrEmployeeLabel.bottomAnchor.constraint(equalTo: businessRegisterButton.topAnchor, constant: -30).isActive = true
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
                                            if Int(birthMonth.text!)! > 12 || Int(birthMonth.text!)! == 0 || Int(birthMonth.text!)! == 00 {
                                                let alert = UIAlertController(title: "Enter a valid Birth Month", message: nil, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                                                    return
                                                }))
                                                self.present(alert, animated: true, completion: nil)
                                                return
                                            } else {
                                                
                                                GlobalVariables.ActualIDs.ActualMonth = Int(birthMonth.text!)
                                            }
                                            
                                            if Int(birthDay.text!)! > 31 || Int(birthDay.text!)! == 00 || Int(birthDay.text!)! == 0 {
                                                
                                                let alert = UIAlertController(title: "Enter a valid Birth Day", message: nil, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                                                    return
                                                }))
                                                self.present(alert, animated: true, completion: nil)
                                                return
                                            } else {
                                                GlobalVariables.ActualIDs.ActualDay = Int(birthDay.text!)
                                            }
                                           
                                            let date = Date()
                                            let calendar = Calendar.current
                                            let year = calendar.component(.year, from: date)
                                            if Int(birthYear.text!)! > year || Int(birthYear.text!)! < year-100 {
                                                let alert = UIAlertController(title: "Enter a valid Birth Year", message: nil, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                                                    return
                                                }))
                                                self.present(alert, animated: true, completion: nil)
                                                return
                                            } else {
                                                GlobalVariables.ActualIDs.ActualYear = Int(birthYear.text!)
                                            }
                                     
                                            
                                            SetupNewUser()
                                            
                                            
                                        } else {
                                           
                                            let alert = UIAlertController(title: "Make sure both passwords match.", message: nil, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                                                return
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                            return
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
            return
        }
        
    }
    
    
    //returns a new list with the customer variables
    func InstantiateCustomerList() -> [String : Any] {
        //this is the new list that will be created.
        let NewUser = [
            GlobalVariables.UserIDs.UserName : GlobalVariables.ActualIDs.ActualName!,
            GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail!.lowercased(),
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
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!.lowercased())").setData(InstantiateCustomerList()) { err in
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
        
        Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!.lowercased(), password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
            
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
    
    
    
    
    
    //MARK:- @objc functions called
    
    @objc func toEmployeeView() {
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserEmployee
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_2RegisterSeque, sender: self)
    }
    
    @objc func toOwnerView() {
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserOwner
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.B_1RegisterSeque, sender: self)
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



