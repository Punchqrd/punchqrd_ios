//
//  B_1Register.swift
//  QR 2.0
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
    
    
    let animationView = AnimationView()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var registerBusiness: UIButton!
    @IBOutlet weak var employeeButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var NameTextField: UITextField! {
        didSet {
            NameTextField.tintColor = UIColor.red
            NameTextField.setIcon(UIImage(systemName: "smiley")!)
        }
    }
    @IBOutlet weak var EmailTextField: UITextField! {
        didSet {
            EmailTextField.tintColor = UIColor.yellow
            EmailTextField.setIcon(UIImage(systemName: "person")!)
        }
    }
    @IBOutlet weak var PasswordTextField: UITextField!{
        didSet {
            PasswordTextField.tintColor = UIColor.green
            PasswordTextField.setIcon(UIImage(systemName: "lock")!)
        }
    }
    @IBOutlet weak var ConfirmPasswordTextField:  UITextField! {
        didSet {
            ConfirmPasswordTextField.tintColor = UIColor.blue
            ConfirmPasswordTextField.setIcon(UIImage(systemName: "lock.fill")!)
        }
    }
    @IBOutlet weak var ErrorLabel : UILabel!
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        self.NameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.RegisterButton)
        self.employeeButton.layer.cornerRadius = 13
        self.registerBusiness.layer.cornerRadius = 13
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
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
      
    
    
    
    
    @IBAction func ConfirmData(_ sender: UIButton) {
        //the next 3 instantiations set the global variables to be used in the final dictionary as what the user inputted in the text fields.
        GlobalVariables.ActualIDs.ActualName = NameTextField.text
        GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
        GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
        
        SetupNewUser()
        
        
        
        
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
    
    @IBAction func OwnerRegisterButton(_ sender: UIButton) {
        GlobalVariables.ActualIDs.ActualUserType = "Owner"
        
    }
    
    
    func verifyEmailAlert(title : String?, message : String?, currentuser: String?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            self.removeLoadingView()
            present(alert, animated: true)
        

    }
    
}

