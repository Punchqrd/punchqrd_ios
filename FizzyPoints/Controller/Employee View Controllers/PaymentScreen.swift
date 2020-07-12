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
    
    
    @IBAction func calculatePoints(_ sender: UIButton) {
        if paymentAmount.text?.isEmpty == false {
            let inputValue = Double(paymentAmount.text!)
            GlobalFunctions.incrementPointsButton(nameofUser: GlobalVariables.ActualIDs.ActualCustomer, nameofBusiness: GlobalVariables.ActualIDs.CurrentNameofBusiness, incrementPoints: inputValue)
            backTwo()
            
            
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
