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
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var CodeTextField: UITextField!{
        didSet {
            CodeTextField.tintColor = UIColor.red
            CodeTextField.setIcon(UIImage(systemName: "pencil")!)
        }
    }
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CodeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.ConfirmButton)
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
    
    
    //MARK:- Actions
    @IBAction func ConfirmAction(_ sender: UIButton) {
        let db = Firestore.firestore()
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        if self.CodeTextField.text!.isEmpty == true {self.ErrorLabel.text = "Enter Code"}
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
                    self.ErrorLabel.text = "No code exists."
                    self.removeLoadingView()
                }
            }
            
        }
        
        
    }
    
    
    
}
