//
//  PaymentScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/12/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class PaymentScreen: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        paymentAmount.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GlobalFunctions.setButtonRadius(button: doneButton)
        doneButton.frame.size.height = 50
    }
    
    //Textfield delegates
   
    
    @IBAction func calculatePoints(_ sender: UIButton) {
        if paymentAmount.text?.isEmpty == false {
            
            var periodCounter = 0
            let valuesInText = paymentAmount.text!
            var charactersArray : [String] = []
            for characters in valuesInText {
                charactersArray.append(String(describing: characters))
            }
            
            for values in charactersArray {
                switch values {
                case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
                    print(values)
                    break
                case ".":
                    periodCounter += 1
                default:
                    self.paymentAmount.text = ""
                    self.paymentAmount.placeholder = "Oops, valid # please."
                    break
                }
                
                
            }
            
            if periodCounter > 0 && periodCounter <= 1 {
                let inputValue = Double(paymentAmount.text!)
                
                
                
                
                
                
                
                let db = Firestore.firestore()
                db.collection(GlobalVariables.UserIDs.CollectionTitle).document(GlobalVariables.ActualIDs.ActualCustomer!).getDocument { (userProfile, err) in
                    
                        if let userProfile = userProfile, userProfile.exists {
                            
                            //this is where the data can be transmuted to the other datafields in the database.
                            let useryear = userProfile.get(GlobalVariables.UserIDs.UserBirthYear)! as! Int
                            let userday = userProfile.get(GlobalVariables.UserIDs.UserBirthDay)!  as! Int
                            let usermonth = userProfile.get(GlobalVariables.UserIDs.UserBirthMonth)!  as! Int
                            let username = userProfile.get(GlobalVariables.UserIDs.UserName)! as! String
                            
                          
                            
                            GlobalFunctions.incrementPointsButton(nameofUser: GlobalVariables.ActualIDs.ActualCustomer, nameofBusiness: GlobalVariables.ActualIDs.CurrentNameofBusiness, incrementPoints: inputValue, currentEmployerEmail: GlobalVariables.ActualIDs.CurrentNameofEmployer, year: useryear, day: userday, month: usermonth, name: username)
                                         
                            self.backTwo()
                            
                            
                        } else {
                            return
                        }
                    
                }
                
                
             
            } else if periodCounter > 1 {
                self.paymentAmount.text = ""
                self.paymentAmount.placeholder = "One too many ."
            }
                   
            
            
            //increment the total amount the user has spent at this business over his hlifetime.
            
        }
    }
    
    func backTwo() {
        self.navigationController?.popToViewController(ofClass: EmployeeHome.self)
    }
    
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
