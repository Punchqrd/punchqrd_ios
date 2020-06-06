//
//  C_1Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class C_1Register : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var CodeTextField: UITextField!{
        didSet {
            CodeTextField.tintColor = UIColor.red
            CodeTextField.setIcon(UIImage(systemName: "pencil")!)
        }
    }
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CodeTextField.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.ConfirmButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func ConfirmAction(_ sender: UIButton) {
        let db = Firestore.firestore()
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        if self.CodeTextField.text!.isEmpty == true {self.ErrorLabel.text = "Enter Code"}
        else{
            let codeData = db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(self.CodeTextField.text!)
            codeData.getDocument { (codeDocument, error) in
                if let codeDocument = codeDocument, codeDocument.exists {
                    GlobalVariables.ActualIDs.employeeAccessCode = self.CodeTextField.text
                    GlobalVariables.ActualIDs.EmployerBusinessName =  (codeDocument.get(GlobalVariables.UserIDs.EmployerBusinessString) as! String)
                    GlobalVariables.ActualIDs.EmployerBusinessEmail = (codeDocument.get(GlobalVariables.UserIDs.EmployerNameString) as! String)
                    
                    //perform the segue
                    
                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.FinalEmployeeRegisterSegue, sender: self)
                } else {self.ErrorLabel.text = "No code exists."}
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
}
