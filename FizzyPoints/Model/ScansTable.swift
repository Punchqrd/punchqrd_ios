//
//  ScansTable.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth


class ScansTable:  UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var scans : [Individual_Scans] = []
    var refresher : UIRefreshControl!

    var currentUserEmail: String?
    var rightView: UIView?
    var parentView: UIView?
    
    init(rightView: UIView, parentView: UIView, currentUserEmail: String?) {
        self.currentUserEmail = currentUserEmail!
        self.rightView = rightView
        self.parentView = parentView
        
        super.init(frame: rightView.frame, style: UITableView.Style.plain)
        self.frame = CGRect(x: 0, y: 0, width: rightView.frame.size.width - 50, height: rightView.frame.size.height - 50)
        self.center.x = rightView.frame.size.width/2
        self.center.y = rightView.frame.size.height/2
        self.layer.cornerRadius = 30
        refreshTableView()


        
        NSObject.initialize()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegateAndRegister() {
        self.dataSource = self
        self.delegate = self
        self.register(UINib(nibName: "Individual_Scans_CellTableViewCell", bundle: nil), forCellReuseIdentifier: "Individual_Scans_CellTableViewCell")
        self.rowHeight = 50
        
    }
    
    func populateData() {
           var countValue = 0
           scans = []
           let db = Firestore.firestore()
           let scans = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentUserEmail!).collection(GlobalVariables.UserIDs.IndividualScans)
           scans.getDocuments { (document, err) in
               for title in document!.documents {
                   countValue += 1
                let price = title.get(GlobalVariables.UserIDs.amountforScan) as! Double
                let customer = title.get(GlobalVariables.UserIDs.customerName) as! String
                let employee = title.get(GlobalVariables.UserIDs.employeeName) as! String
                self.scans.append(Individual_Scans(Date: title.documentID, Price: price, Customer: customer, Employee: employee))
                
                
                   DispatchQueue.main.async { self.reloadData() }
                   self.reloadData()
                   self.refresher.endRefreshing()
                   
                   
               }
           }
           
           
           setDelegateAndRegister()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "Individual_Scans_CellTableViewCell", for: indexPath) as! Individual_Scans_CellTableViewCell
        cell.setupLabel(dateValue: scans[indexPath.row].Date!, price: scans[indexPath.row].Price! )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //when the user choses a cell from the index path
        displayCustomerInformation(priceValue: scans[indexPath.row].Price!, dateValue: scans[indexPath.row].Date!, customerScanned: scans[indexPath.row].Customer!, employeeScanned: scans[indexPath.row].Employee!, ticket: indexPath.row) //passes the email of the customer
         
         self.deselectRow(at: indexPath, animated: true)


     }
     
     
     
    
     
    func displayCustomerInformation(priceValue: Double, dateValue: String, customerScanned: String, employeeScanned: String, ticket: Int) {
        let customerInformation = ScanDataView(parentView: rightView!, priceValue: priceValue, dateValue: dateValue, customerScanned: customerScanned, employeeScanned: employeeScanned, ticket: ticket, tableView: self)
         customerInformation.setupView()
         
     }
    
    
    //function to refresh the table view
       func refreshTableView() {
           //this is the refresh list variables to enable a refresh for the UITableView
          
           self.refresher = UIRefreshControl()
           refresher.tintColor = .white
           self.refresher.addTarget(self, action: #selector(ScansTable.refresh), for: UIControl.Event.valueChanged)
           self.addSubview(self.refresher)
           
           
       }
       
       @objc func refresh()
       {
           //calls the function below
           
           refreshData()
           
       }
       
      
       
       //function to refresh the data on the page
       func refreshData() {
         
          
           let colorHolder : [UIColor] = [.systemPurple]
           let randomColor = 0
           self.refresher.backgroundColor = colorHolder[randomColor].withAlphaComponent(0.8)
           
           //self.BusinessList.reloadData()
           DispatchQueue.main.async {
               self.populateData()
               self.reloadData()
               self.dataSource = self
//               self.register(UINib(nibName: "Individual_Scans_CellTableViewCell", bundle: nil), forCellReuseIdentifier: "Individual_Scans_CellTableViewCell")
               
               
           }
           

       }
}
