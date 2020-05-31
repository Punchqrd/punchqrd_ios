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

class LoginScreen : UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //login button
    @IBAction func LoginAction(_ sender: UIButton) {
        
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
                document.getDocument(source: .cache) { (dataPiece, error) in
                    if let error = error {self.ErrorLabel.text = error.localizedDescription
                        print(error.localizedDescription)
                    }
                    //this is where the segue logic happens
                    else {
                        GlobalVariables.ActualIDs.CurrentUser = self.EmailTextField.text!
                        let data = dataPiece?.get(GlobalVariables.UserIDs.UserType) as! String
                        if data == GlobalVariables.UserIDs.UserCustomer {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToCustomerHomeScreen, sender: self)}
                        if data == GlobalVariables.UserIDs.UserEmployee {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.EmployeeLoginSegue, sender: self)}
                        if data == GlobalVariables.UserIDs.UserOwner {self.performSegue(withIdentifier: GlobalVariables.SegueIDs.ToOwnerHomeScreen, sender: self)}
                        }
                   }
               }
          }
    }
    
    
    
}
