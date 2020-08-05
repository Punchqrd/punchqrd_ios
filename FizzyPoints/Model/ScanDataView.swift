//
//  ScanDataView.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class ScanDataView: UIView, UITextFieldDelegate {
    
    var gesture = UITapGestureRecognizer()
    
    var parentView: UIView?
    var priceValue: Double
    var priceLabel = UILabel()
    var dateValue: String
    var dateLabel = UILabel()
    var customerScanned: String
    var customerScannedLabel = UILabel()
    var employeeScanned: String
    var employeeScannedLabel = UILabel()
    var ticket: Int
    var parentTableView: UITableView
    
    var titleLabel = UILabel()
    
    var changeButton = UIButton()
    var textFieldInput = UITextField()
    var textFieldView = UIView()
    
    var nameBusiness: String
    
    private lazy var animationView1: AnimationView = {
        let view = AnimationView()
        return view
    }()
    
    
    
    
    init(parentView: UIView, priceValue: Double, dateValue: String, customerScanned: String, employeeScanned: String, ticket: Int, tableView: UITableView, nameBusiness: String) {
        self.parentView = parentView
        self.priceValue = priceValue
        self.customerScanned = customerScanned
        self.employeeScanned = employeeScanned
        self.dateValue = dateValue
        self.ticket = ticket
        self.parentTableView = tableView
        self.nameBusiness = nameBusiness
        super.init(frame: parentView.frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setupView() {
        
        
        
        self.frame = CGRect(x: 0, y: 0, width: parentView!.frame.size.width + 10, height: parentView!.frame.size.height + 10)
        self.backgroundColor = .systemPurple
        self.layer.cornerRadius = 30.0
        self.center.x = parentView!.frame.size.width/2
        self.center.y = -parentView!.frame.size.height/2
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.center.y = self.parentView!.frame.size.height/2
        }, completion: nil)
        
        
        
        
        //labels setup
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.15, height: 20)
        titleLabel.center.x = self.frame.size.width/2
        titleLabel.center.y = self.frame.size.height/9
        titleLabel.text = String(describing: "Ticket: \(ticket+1)")
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        self.addSubview(titleLabel)
        
        
        priceLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.15, height: 20)
        priceLabel.center.x = self.frame.size.width/2
        priceLabel.center.y = self.frame.size.height/8 + 160
        priceLabel.text = String(describing: "For $\(priceValue)")
        priceLabel.textAlignment = .left
        priceLabel.textColor = .white
        priceLabel.font = UIFont(name: "Poppins", size: 15)
        self.addSubview(priceLabel)
        
        dateLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.15, height: 20)
        dateLabel.center.x = self.frame.size.width/2
        dateLabel.center.y = self.frame.size.height/8 + 120
        dateLabel.text = String(describing: "On: \(dateValue)")
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "Poppins", size: 15)
        self.addSubview(dateLabel)
        
        customerScannedLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.15, height: 20)
        customerScannedLabel.center.x = self.frame.size.width/2
        customerScannedLabel.center.y = self.frame.size.height/8 + 80
        customerScannedLabel.text = String(describing: "Customer: \(customerScanned)")
        customerScannedLabel.textAlignment = .left
        customerScannedLabel.textColor = .white
        customerScannedLabel.font = UIFont(name: "Poppins", size: 15)
        self.addSubview(customerScannedLabel)
        
        employeeScannedLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.15, height: 20)
        employeeScannedLabel.center.x = self.frame.size.width/2
        employeeScannedLabel.center.y = self.frame.size.height/8 + 40
        employeeScannedLabel.text = String(describing: "Employee: \(employeeScanned)")
        employeeScannedLabel.textAlignment = .left
        employeeScannedLabel.textColor = .white
        employeeScannedLabel.font = UIFont(name: "Poppins", size: 15)
        self.addSubview(employeeScannedLabel)
        //then add button to change the value in the database ///might have to create an extra funtion that displays another view
        ///can be a single textfield and a button that allows the new inputted value to change the values in the database.
        
        
        changeButton.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.3, height: 60)
        changeButton.center.x = self.frame.size.width/2
        changeButton.center.y = self.frame.size.height - 100
        changeButton.addTarget(self, action: #selector(changeToNewValue), for: .touchUpInside)
        changeButton.titleLabel?.font =  UIFont(name: "Poppins", size: 15)
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.setTitle("Update", for: .normal)
        changeButton.backgroundColor = .clear
        changeButton.layer.cornerRadius = self.frame.size.width/2
        self.addSubview(changeButton)
        
        textFieldView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.3, height: 50)
        textFieldView.center.x = self.frame.size.width/2
        textFieldView.center.y = self.frame.size.height - changeButton.frame.size.height*2.1 - 50
        textFieldView.backgroundColor = .white
        textFieldView.layer.cornerRadius = 20
        
        textFieldInput.frame = CGRect(x: 0, y: 0, width: textFieldView.frame.size.width - 20, height: textFieldView.frame.size.height - 10)
        textFieldInput.center = textFieldView.center
        textFieldInput.keyboardType = .decimalPad
        textFieldInput.tintColor = .systemGreen
        textFieldInput.textColor = .black
        textFieldInput.backgroundColor = .clear
        textFieldInput.font =  UIFont(name: "Poppins", size: 15)
        textFieldInput.delegate = self
        textFieldInput.attributedPlaceholder = NSAttributedString(string: "Update Ticket $",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.addSubview(textFieldInput)
        self.addSubview(textFieldView)
        self.sendSubviewToBack(textFieldView)
        
        self.gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.addGestureRecognizer(gesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.checkAction))
        swipeGesture.direction = .up
        parentView?.addGestureRecognizer(swipeGesture)
        parentView?.addSubview(self)
        
        
    }
    
    @objc func checkAction() {
        
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.center.y = -self.parentView!.frame.size.height
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                self.parentTableView.reloadData()
                self.removeFromSuperview()
                
            }
        }, completion: nil)
        
        
    }
    
    
    //now need to reload the data and update the database.
    @objc func changeToNewValue() {
        
        
        if textFieldInput.text?.isEmpty == false {
            
            var periodCounter = 0
            let valuesInText = textFieldInput.text!
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
                    self.textFieldInput.text = ""
                    self.textFieldInput.placeholder = "Oops, valid # please."
                    
                    break
                }
                
                
            }
            
            if periodCounter > 0 && periodCounter <= 1 {
                
                
                
                
                
                
                
                //setup loading view
                let inputValue = Double(textFieldInput.text!)
                
                setupAnimation(parentView: self.changeButton, animationView: animationView1, animationName: "BeerLoader")
                
                //this is where the dispatching will take place.
                
                
                let db = Firestore.firestore()
                let individualScansCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.IndividualScans).document(dateValue)
                individualScansCollection.getDocument { (doc, error) in
                    if let doc = doc, doc.exists {
                        individualScansCollection.updateData([GlobalVariables.UserIDs.amountforScan : inputValue!])
                        //change the value in the database for the owner
                        self.changeAggregateValue(oldPrice: self.priceValue, newPrice: inputValue!)
                        //change the value of total spent for the customer
                        self.changeAggregateValueForCustomerTable(oldPrice: self.priceValue, newPrice: inputValue!)
                        
                        
                        self.changeAggregateValueForCustomer(oldPrice: self.priceValue, newPrice: inputValue!, nameofUser: self.customerScanned, nameofBusiness: self.nameBusiness)
                        
                        self.animationView1.removeFromSuperview()
                        self.changeButton.tintColor = .green
                        self.priceValue = inputValue!
                        self.priceLabel.text = String(describing: "For $\(inputValue!)")
                        self.changeButton.titleLabel?.font =  UIFont(name: "Poppins", size: 15)
                        self.changeButton.setTitleColor(.white, for: .normal)
                        self.changeButton.setTitle("Updated!", for: .normal)
                        DispatchQueue.main.async {    self.parentTableView.reloadData()}
                        self.parentTableView.reloadData()
                        
                        
                    } else {
                        return
                            self.animationView1.removeFromSuperview()
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            } else if periodCounter > 1 {
                self.textFieldInput.text = ""
                self.textFieldInput.placeholder = "One too many ."
            }
            
            
            
            //increment the total amount the user has spent at this business over his hlifetime.
            
        }
        
    }
    
    
    
    
    
    func setupAnimation(parentView: UIView, animationView: AnimationView, animationName: String) {
        animationView.animation = Animation.named(animationName)
        animationView.frame = parentView.frame
        animationView.center.x = parentView.frame.width/2
        animationView.center.y = parentView.frame.height/2
        animationView.contentMode = .scaleAspectFit
        
        animationView.layer.cornerRadius = 30
        animationView.backgroundColor = .systemPurple
        animationView.play()
        animationView.loopMode = .loop
        parentView.addSubview(animationView)
    }
    
    
    func changeAggregateValue(oldPrice: Double, newPrice: Double) {
        let db = Firestore.firestore()
        let totals = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        totals.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                var retrievedRevenue = doc.get(GlobalVariables.UserIDs.OwnerRevenueString) as! Double
                retrievedRevenue -= oldPrice
                retrievedRevenue += newPrice
                totals.updateData([GlobalVariables.UserIDs.OwnerRevenueString:  retrievedRevenue])
                
                
                
                
            }
            
            
        }
    }
    
    
    func changeAggregateValueForCustomerTable(oldPrice: Double, newPrice: Double) {
        let db = Firestore.firestore()
        let employerBusiness = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!)
        let employerUsersScannedData = employerBusiness.collection(GlobalVariables.UserIDs.CustomersScannedCollectionTitle).document(self.customerScanned)
        employerUsersScannedData.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                //retrieve the value the customer spent in the past.
                var totalSpent = (doc.get(GlobalVariables.UserIDs.CustomerTotalSpent)! as! Double).rounded(toPlaces: 2)
                
                totalSpent -= oldPrice
                totalSpent += newPrice
                employerUsersScannedData.updateData([GlobalVariables.UserIDs.CustomerTotalSpent: totalSpent])
                
                
            }
        }
        
        
        
        
    }
    
    
    //this one
    func changeAggregateValueForCustomer(oldPrice: Double, newPrice: Double, nameofUser: String, nameofBusiness: String) {
        print(nameofUser)
        
        let db = Firestore.firestore()
        let CustomerCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(nameofBusiness
        )
        print(nameofBusiness)
       CustomerCollection.getDocument { (doc, error) in
        
            if let doc = doc, doc.exists {
                var totalSpent = (doc.get(GlobalVariables.UserIDs.CustomerTotalSpent)! as! Double).rounded(toPlaces: 2)
                print(totalSpent)

                totalSpent -= oldPrice
                totalSpent += newPrice
                CustomerCollection.updateData([GlobalVariables.UserIDs.CustomerTotalSpent: totalSpent])
                print(totalSpent)
                
            }
        }
       
        
    }
    
    
    
    
    
    
}
