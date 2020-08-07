//
//  C_1Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import Lottie

class C_1Register : UIViewController, UITextFieldDelegate {
    //variables/objects
    let animationView = AnimationView()
    
    //outlets
    var ConfirmButton = ActionButton(backgroundColor: .black, title: "Confirm", image: nil)
    var CodeTextField = UITextField()
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()

        self.CodeTextField.delegate = self
        
        setupView()
        
        navigationController?.navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.black,
              NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        navigationItem.title = "So you're an employee."
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupView() {
        view.addSubview(ConfirmButton)
        ConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        ConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        ConfirmButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        ConfirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        ConfirmButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        ConfirmButton.addTarget(self, action: #selector(ConfirmAction), for: .touchUpInside)
        
        view.addSubview(CodeTextField)
        CodeTextField.translatesAutoresizingMaskIntoConstraints = false
        CodeTextField.widthAnchor.constraint(equalTo: ConfirmButton.widthAnchor).isActive = true
        CodeTextField.bottomAnchor.constraint(equalTo: ConfirmButton.topAnchor, constant: -10).isActive = true
        CodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        CodeTextField.textColor = .black
        CodeTextField.borderStyle = .none
        CodeTextField.placeholder = "Code"
        CodeTextField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        CodeTextField.textAlignment = .left
    }
    
    //MARK:-Animations
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func addLoadingView() {
        self.setupAnimation()
    }
    
    
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
    
    
    func removeLoadingView() {
        self.animationView.stop()
        self.animationView.removeFromSuperview()
        
    }
    
    
    //MARK:- Actions
    @objc func ConfirmAction() {
        let db = Firestore.firestore()
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        if self.CodeTextField.text!.isEmpty == true {let alert = UIAlertController(title: "Enter a code.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (alert: UIAlertAction) in
                return
            }))
            self.present(alert, animated: true, completion: nil)}
        else{
            self.addLoadingView()
            let codeData = db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(self.CodeTextField.text!)
            codeData.getDocument { (codeDocument, error) in
                if let codeDocument = codeDocument, codeDocument.exists {
                    GlobalVariables.ActualIDs.employeeAccessCode = self.CodeTextField.text
                    GlobalVariables.ActualIDs.EmployerBusinessName =  (codeDocument.get(GlobalVariables.UserIDs.EmployerBusinessString) as! String)
                    GlobalVariables.ActualIDs.EmployerBusinessEmail = (codeDocument.get(GlobalVariables.UserIDs.EmployerNameString) as! String)
                    
                    //perform the segue
                    self.removeLoadingView()
                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.FinalEmployeeRegisterSegue, sender: self)
                } else {
                    let alert = UIAlertController(title: "This code doesn't exist.", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (alert: UIAlertAction) in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    self.removeLoadingView()
                }
            }
            
        }
        
        
    }
    
    
    
}
