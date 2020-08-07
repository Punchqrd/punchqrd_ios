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
    
    var RandomCodeButton = ActionButton(backgroundColor: .systemGray, title: "Generate", image: nil)
    var codeLabel = UITextView()
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.codeLabel.delegate = self
        self.codeLabel.isEditable = false
        self.RandomCodeButton.isEnabled = true
        navigationController?.navigationBar.titleTextAttributes =
                            [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
                             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
                       
        navigationItem.title = "Add Employee"
        
        setupView()
        
        
        //present an alert to the user with instructions
        let alert = UIAlertController(title: "Generate a Code", message: "Send it to an employee, they'll need it to register.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
            return
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        GlobalFunctions.setButtonRadius(button: self.RandomCodeButton)
    }
    
    
    func setupView() {
        view.addSubview(RandomCodeButton)
        RandomCodeButton.translatesAutoresizingMaskIntoConstraints = false
        RandomCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        RandomCodeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        RandomCodeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        RandomCodeButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        RandomCodeButton.addTarget(self, action: #selector(RandomCodeAction), for: .touchUpInside)
        
        view.addSubview(codeLabel)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.isEditable = true
        codeLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        codeLabel.bottomAnchor.constraint(equalTo: RandomCodeButton.topAnchor, constant: -20).isActive = true
        codeLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 20)
        codeLabel.textColor = .black
        codeLabel.textAlignment = .natural
        
        
    }
    
    //MARK:- Actions
    
    
    @objc func RandomCodeAction() {
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

