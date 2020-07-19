//
//  CustomerInformationView.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/18/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore


class CustomerInformationView: UIView {
    

    //initializers
    var customerEmail: String?
    var customerName: String?
    var customerBirthDate: String?
    var totalSpent: Double?
    var totalScans: Int?
    var superView: UIView?
    var userEmail: String?
    var parentTable: UITableView?
    
    let totalScansLabel = UILabel()
    let totalSpentLabel = UILabel()
    let customerBirthDateLabel = UILabel()
    let customerNameLabel = UILabel()
    let customerEmailLabel = UILabel()
    
    init(userEmail: String?, superView: UIView, customerEmail: String?, parentTable: UITableView) {
        self.userEmail = userEmail
        self.superView = superView
        self.customerEmail = customerEmail
        self.parentTable = parentTable
        
        //initialize it with the superviews frame bounds.
        super.init(frame: superView.frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        self.backgroundColor = UIColor.systemPurple.withAlphaComponent(1)
        self.layer.cornerRadius = 30
        self.frame = CGRect(x: 0, y: 0, width: self.superView!.frame.size.width/1.2, height: self.superView!.frame.size.height/1.35)
        self.center.x = -self.superView!.frame.width/2
        self.center.y = self.superView!.frame.height/2
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.addGestureRecognizer(gesture)
              
        self.superView?.addSubview(self)
        
        
      
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            
            self.center.x = self.superView!.frame.width/2
            
                  
            
            
        }, completion: nil)
        
        
        setupLabels()
        populateData()
    }
    
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            
            self.center.x = -self.superView!.frame.width/2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.removeFromSuperview()
                
                
            }
            
            
        }, completion: nil)
        
    }
    
    
    
    func setupLabels() {
        totalScansLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        totalScansLabel.center.x = self.frame.width/1.5
        totalScansLabel.center.y = self.frame.size.height/8 + 160
        totalScansLabel.font = UIFont(name: "Poppins", size: 15)
        totalScansLabel.textColor = .white
        
        self.addSubview(totalScansLabel)
        
        
        totalSpentLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        totalSpentLabel.center.x = self.frame.width/1.5
        totalSpentLabel.center.y = self.frame.size.height/8 + 120
        totalSpentLabel.font = UIFont(name: "Poppins", size: 15)
        totalSpentLabel.textColor = .white
        
        self.addSubview(totalSpentLabel)
        
        
        customerNameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        customerNameLabel.center.x = self.frame.width/1.5
        customerNameLabel.center.y = self.frame.size.height/8
        customerNameLabel.font = UIFont(name: "Poppins", size: 15)
        customerNameLabel.textColor = .white
        
        self.addSubview(customerNameLabel)
        
        
        customerEmailLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        customerEmailLabel.center.x = self.frame.width/1.5
        customerEmailLabel.center.y = self.frame.size.height/8 + 40
        customerEmailLabel.font = UIFont(name: "Poppins", size: 15)
        customerEmailLabel.textColor = .white
        
        self.addSubview(customerEmailLabel)
        
        
        customerBirthDateLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        customerBirthDateLabel.center.x = self.frame.width/1.5
        customerBirthDateLabel.center.y = self.frame.size.height/8 + 80
        customerBirthDateLabel.font = UIFont(name: "Poppins", size: 15)
        customerBirthDateLabel.textColor = .white
        
        self.addSubview(customerBirthDateLabel)
        
        
        
        
        
    }
    
    func populateData() {
        let db = Firestore.firestore()
        let customerInfo = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(userEmail!).collection("Customers").document(customerEmail!)
        customerInfo.getDocument { (document, err) in
            if let document = document, document.exists {
                //populate the data in the labels
                
                self.customerName = (document.get(GlobalVariables.UserIDs.UserName) as! String)
                
                let birthMonth = document.get(GlobalVariables.UserIDs.UserBirthMonth)!
                let birthDay = document.get(GlobalVariables.UserIDs.UserBirthDay)!
                let birthYear = document.get(GlobalVariables.UserIDs.UserBirthYear)!
                
                self.customerBirthDate = "\(String(describing: birthMonth))" + "\\" + "\(String(describing: birthDay))" + "\\" + "\(String(describing: birthYear))"
                self.totalSpent = (document.get(GlobalVariables.UserIDs.CustomerTotalSpent)! as! Double)
                self.totalScans = (document.get(GlobalVariables.UserIDs.ScansRecievedString)! as! Int)
                
                
                //now populate the text
                self.customerNameLabel.text = "Name: \(String(describing: self.customerName!))"
                self.customerBirthDateLabel.text = "BirthDay: \(String(describing: self.customerBirthDate!))"
                self.totalScansLabel.text = "Scanned: \(String(describing: self.totalScans!))" + " times"
                self.totalSpentLabel.text = "Spent: $\(String(describing: self.totalSpent!))"
                self.customerEmailLabel.text = "Email: \(String(describing: self.customerEmail!))"
                
                
                
                
            }
        }
        
    }
    
    func removeView() {
        self.removeFromSuperview()
    }
    
    
}
