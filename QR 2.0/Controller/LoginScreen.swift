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





class LoginScreen : UIViewController, UITextFieldDelegate {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordTextField.delegate = self
        self.EmailTextField.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.RegisterButton)
        GlobalFunctions.setButtonRadius(button: self.LoginButton)
        self.navigationController?.navigationBar.isHidden = true
        PasswordTextField.text = nil
        EmailTextField.text = nil
        
        
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
    
    //login function
    func login () {
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (user, error) in
            if error != nil { self.ErrorLabel.text = error?.localizedDescription }
            else {
                
                //fetch the document array for the user.
                let document = self.db.collection(GlobalVariables.UserIDs.CollectionTitle).document(self.EmailTextField.text!)
                //we not have a document
                document.getDocument { (dataPiece, error) in
                    if let error = error {self.ErrorLabel.text = error.localizedDescription
                        print(error.localizedDescription)
                    }
                    //this is where the segue logic happens
                    else {
                        GlobalVariables.ActualIDs.CurrentUser = self.EmailTextField.text!
                        let data = dataPiece?.get(GlobalVariables.UserIDs.UserType) as! String
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
                        if data == GlobalVariables.UserIDs.UserCustomer {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)}
                        if data == GlobalVariables.UserIDs.UserEmployee {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.EmployeeLoginSegue, sender: self)}
                        if data == GlobalVariables.UserIDs.UserOwner {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToOwnerHomeScreen, sender: self)}
                        }
                   }
               }
          }
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
