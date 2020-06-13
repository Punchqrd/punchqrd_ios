//
//  SecondAddEmployeeScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SecondAddEmployeeScreen: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var RandomCodeButton: UIButton!
    @IBOutlet weak var codeLabel: UITextView!
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.codeLabel.delegate = self
        self.codeLabel.isEditable = false
        self.RandomCodeButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        GlobalFunctions.setButtonRadius(button: self.RandomCodeButton)
    }
    
    //MARK:- Actions
    @IBAction func RandomCodeAction(_ sender: UIButton) {
        self.codeLabel.text = self.randomString(length: 15)
        self.RandomCodeButton.backgroundColor = .gray
        self.RandomCodeButton.isEnabled = false
        
        //now create the code displayed in the database
        let db = Firestore.firestore()
        let businessUserEmail = Auth.auth().currentUser?.email!
        let businessName = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(businessUserEmail!)
        businessName.getDocument { (document, error) in
            if let error = error {print(error.localizedDescription)}
            else {
                let employerBusinessName = document?.get(GlobalVariables.UserIDs.BusinessName)
                //found the name
                //setup the new branch in the email
                db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(self.codeLabel.text).setData([GlobalVariables.UserIDs.EmployerNameString : businessUserEmail!, GlobalVariables.UserIDs.EmployerBusinessString : employerBusinessName as! String])
            }
        }
        
        
        
    }
    
    //MARK:- Suplimentary functions
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}

