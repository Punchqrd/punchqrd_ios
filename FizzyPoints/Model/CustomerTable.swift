//
//  CustomerTable.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/17/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class CustomerTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var currentUserEmail: String?
    var leftView: UIView?
    var superView: UIView?
    var customers : [CustomerClass] = []
    
   
    
    
    
    init(currentUserEmail: String?, leftView: UIView?, superView: UIView?) {
        self.currentUserEmail = currentUserEmail
        self.leftView = leftView
        self.superView = superView
        super.init(frame: leftView!.frame, style: UITableView.Style.plain)
        self.frame = CGRect(x: 0, y: 0, width: leftView!.frame.size.width - 50, height: leftView!.frame.size.height - 50)
        self.center.x = leftView!.frame.size.width/2
        self.center.y = leftView!.frame.size.height/2
        self.layer.cornerRadius = 30
        

      
        NSObject.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegateAndRegister() {
        self.dataSource = self
        self.delegate = self
        self.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "CustomerCell")
        self.rowHeight = 50
        
    }
   
    func populateData() {
        var countValue = 0
        
        let db = Firestore.firestore()
        let customers = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentUserEmail!).collection(GlobalVariables.UserIDs.CustomersScannedCollectionTitle)
        customers.getDocuments { (document, err) in
            for title in document!.documents {
                countValue += 1
                
                self.customers.append(CustomerClass(email: title.documentID))
                DispatchQueue.main.async { self.reloadData() }
                self.reloadData()
                    
                
                
            }
        }
        
        
        setDelegateAndRegister()
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(customers.count)
        let cell = self.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
        cell.setupLabel(nameofCustomer: customers[indexPath.row].email!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when the user choses a cell from the index path
        displayCustomerInformation(customer: customers[indexPath.row].email!) //passes the email of the customer
        
        self.deselectRow(at: indexPath, animated: true)


    }
    
    
    
   
    
    func displayCustomerInformation(customer: String) {
        let customerInformation = CustomerInformationView(userEmail: Auth.auth().currentUser?.email!, superView: self.superView!, customerEmail: customer, parentTable: self)
        customerInformation.setupView()
        
    }

    
    
    
    
    
    
    
    
    
}
