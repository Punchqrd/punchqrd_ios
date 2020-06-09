//
//  B_2_2Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import StoreKit

class B_2_2Register : UIViewController, UITextFieldDelegate, SKPaymentTransactionObserver {
    
    
   
    let grayView = UIView()
    let productID = "com.SebastianBarry.QR20.BusinessSub"
    let db = Firestore.firestore()
    @IBOutlet weak var EmailTextField: UITextField! {
        didSet {
            EmailTextField.tintColor = UIColor.green
            EmailTextField.setIcon(UIImage(systemName: "person")!)
        }
    }
    @IBOutlet weak var PasswordTextField: UITextField! {
        didSet {
            PasswordTextField.tintColor = UIColor.blue
            PasswordTextField.setIcon(UIImage(systemName: "lock")!)
        }
    }
    @IBOutlet weak var ConfirmPasswordTextField: UITextField! {
        didSet {
            ConfirmPasswordTextField.tintColor = UIColor.red
            ConfirmPasswordTextField.setIcon(UIImage(systemName: "lock.fill")!)
        }
    }
    
    @IBOutlet weak var SetupButton: UIButton!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    override func viewDidLoad() {
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.ConfirmPasswordTextField.delegate = self
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        self.grayView.frame.size.height = self.view.bounds.height
        self.grayView.frame.size.width = self.view.bounds.width
        self.grayView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        self.view.addSubview(self.grayView)
        
        
        setupPremiumPurchase()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalFunctions.setButtonRadius(button: self.SetupButton)
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    //MARK:- Setup up the purchase function for business account creation.
    
    func setupPremiumPurchase() {
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
            
            
        } else {
            print("Cannot make payments")
        }
        
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transactions in transactions {
            if transactions.transactionState == .purchased {
                //user payment was successful
                print("transaction was successful")
                SKPaymentQueue.default().finishTransaction(transactions)
                self.grayView.removeFromSuperview()
            } else if transactions.transactionState == .failed {
                //payment failed
                if let error = transactions.error {
                    let errorDescription = error.localizedDescription
                    SKPaymentQueue.default().finishTransaction(transactions)

                    print(errorDescription)

                }
                SKPaymentQueue.default().finishTransaction(transactions)
                self.navigationController?.popViewController(animated: true)
            } else if transactions.transactionState == .purchased {
                self.grayView.removeFromSuperview()
            }
        }
       }
    
    //setup a new user function
       func SetupNewUser () {
             
             

             Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
                 if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
                 else {
                   
                   print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                   self.SetupFirebaseData()
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {print(error.localizedDescription)} else {
                            self.verifyEmailAlert(title: "Check your email!", message: "We sent a link to verify your account.", currentuser: nil)
                        }
                    })
                     
                 }
             }
             
         }
    
    func verifyEmailAlert(title : String?, message : String?, currentuser: String?) {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               
               alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                   self.navigationController?.popToRootViewController(animated: true)
               }))
               
               
               present(alert, animated: true)
           

       }
    
    //create a new list with the new variables
      func InstantiateOwnerList() -> [String : Any] {
          
          let NewUser = [
              
              GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail, //(0)
              GlobalVariables.UserIDs.BusinessName : GlobalVariables.ActualIDs.ActualBusinessName, //(1)
              GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword, //(2)
              GlobalVariables.UserIDs.UserType: GlobalVariables.ActualIDs.ActualUserType, //(3)
              GlobalVariables.UserIDs.UserZipCode: GlobalVariables.ActualIDs.ActualZipCode //(4)
          ]
          
          return NewUser as [String : Any]
          
      }
      
      //setup the firebase for the new owner with a list of owner variables
      func SetupFirebaseData () {
          db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!)").setData(InstantiateOwnerList()) { err in
              if let err = err {
                  print("Error writing document: \(err)")
              } else {
                  print("Document successfully written!")
              }
          }
      }
       
       
    @IBAction func ConfirmBusiness(_ sender: UIButton) {
        //the next few lines set the global data variables as the textfield user inputted data for use in data set.
        GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
        GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
        //***Still need to set the address
        SetupNewUser()
    }
    
    
}
