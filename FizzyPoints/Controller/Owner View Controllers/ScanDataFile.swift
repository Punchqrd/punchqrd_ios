//
//  ScanDataFile.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/7/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ScanDataFile : UIViewController {
    
    var businessDataHolder : [OwnerDataObject] = []
    
    //view variables
    let bottomView = UIView()
    let middleView = UIView()
    
    let totalScansView = UIView()
    let totalScansValue = UILabel()
                                                                        
    let averageRevenueView = UIView()
    let averageRevenueLabel = UILabel()
    
    let totalRevenueView = UIView()
    let totalRevenueLabel = UILabel()
    
    
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveValuesFromDataBase()
        
        
        
        //setup the data when the view loads.
        //must include some sort of guard if the internet is poor.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMiddleView()
        
    }
    
    //MARK:- Suplimentary functions
    
    func retrieveValuesFromDataBase() {
        
        let db = Firestore.firestore()
        let totals = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        totals.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                let retrievedRevenue = doc.get(GlobalVariables.UserIDs.OwnerRevenueString) as! Double
                let retrievedScans = doc.get(GlobalVariables.UserIDs.CustomerPurchasesString) as! Double
                let averageRevenue = retrievedRevenue/retrievedScans
                
                
                let newData = OwnerDataObject(totalScans: Int(retrievedScans), totalRevenue: retrievedRevenue, totalRedemptions: 0, averageRevenue: averageRevenue)
                self.businessDataHolder.append(newData)
                
                
                self.totalScansValue.text = String(describing: self.businessDataHolder[0].totalScans!)
                self.totalRevenueLabel.text = "$\(String(describing: self.businessDataHolder[0].totalRevenue!.rounded(toPlaces: 2)))"
                self.averageRevenueLabel.text = "$\(String(describing: self.businessDataHolder[0].averageRevenue!.rounded(toPlaces: 2)))"
                
                //animate the values
                
            } else {
                self.businessDataHolder.append(OwnerDataObject(totalScans: 0, totalRevenue: 0, totalRedemptions: 0, averageRevenue: 0))
                
                self.totalScansValue.text = String(describing: self.businessDataHolder[0].totalScans!)
                self.totalRevenueLabel.text = "$0"
                self.averageRevenueLabel.text = "$0"
            }
            
            
        }
    }
    
    //function to setup the views.
    //first view to setup is the middle view
    func setupMiddleView() {
        //setup the middle container view
        middleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/1.2, height: self.view.frame.size.height/1.4)
        middleView.center.x = self.view.frame.size.width/2
        middleView.center.y = self.view.center.y
        middleView.backgroundColor = .white
        self.view.addSubview(middleView)
        setupTotalScansView(parentView: middleView)
        setupTotalRevenueView(parentView: middleView)
        setupAverageRevenueView(parentView: middleView)
        
        
        //setup the bottom view
        bottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - middleView.frame.size.height - 150)
        bottomView.center.x = self.view.center.x
        bottomView.center.y = self.view.frame.size.height - bottomView.frame.size.height/2
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        
        
        //setup the input variables for the main view. (average, total, scans, etc.)
        
        
        
    }
    
    func setupShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
    }
    
    func setupTotalScansView(parentView: UIView) {
        totalScansView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalScansView.center.x = parentView.frame.size.width/4
        totalScansView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.9
        totalScansView.backgroundColor = .purple
        totalScansView.layer.cornerRadius = 30
        
        setupShadow(view: totalScansView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: totalScansView.frame.size.width, height: 30)
        totalLabel.center.x = totalScansView.frame.size.width/2
        totalLabel.center.y = totalScansView.frame.size.height/3.5
        totalLabel.text = "Total Scans"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        totalScansView.addSubview(totalLabel)
        
        totalScansValue.frame = CGRect(x: 0, y: 0, width: totalScansView.frame.size.width, height: 40)
        totalScansValue.center.x = totalScansView.frame.size.width/2
        totalScansValue.center.y = totalScansView.frame.size.height - totalScansView.frame.size.height/2.2
        totalScansValue.textColor = .white
        totalScansValue.font =  UIFont(name: "Poppins-Bold", size: 30)
        totalScansValue.textAlignment = .center
        totalScansView.addSubview(totalScansValue)
        setupShadow(view: totalLabel)
        
        
        
        
        
        
        parentView.addSubview(totalScansView)
        
        
    }
    
    
    func setupTotalRevenueView(parentView: UIView) {
        totalRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalRevenueView.center.x = parentView.frame.size.width - totalRevenueView.frame.size.width/1.5
        totalRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        totalRevenueView.backgroundColor = .purple
        totalRevenueView.layer.cornerRadius = 30
        
        setupShadow(view: totalRevenueView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: totalRevenueView.frame.size.width, height: 30)
        totalLabel.center.x = totalRevenueView.frame.size.width/2
        
        
        totalLabel.center.y = totalRevenueView.frame.size.height/3.5
        totalLabel.text = "Total Revenue"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        totalRevenueView.addSubview(totalLabel)
        
        totalRevenueLabel.frame = CGRect(x: 0, y: 0, width: totalRevenueView.frame.size.width, height: 40)
        totalRevenueLabel.center.x = totalRevenueView.frame.size.width/2
        totalRevenueLabel.center.y = totalRevenueView.frame.size.height - totalRevenueView.frame.size.height/2.2
        totalRevenueLabel.textColor = .white
        totalRevenueLabel.font =  UIFont(name: "Poppins-Bold", size: 25)
        totalRevenueLabel.textAlignment = .center
        totalRevenueView.addSubview(totalRevenueLabel)
        setupShadow(view: totalLabel)
        
        
        
        
        
        
        
        parentView.addSubview(totalRevenueView)
        
        
    }
    
    
    func setupAverageRevenueView(parentView: UIView) {
        averageRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        averageRevenueView.center.x = parentView.frame.size.width/4
        averageRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        averageRevenueView.backgroundColor = .purple
        averageRevenueView.layer.cornerRadius = 30
        
        setupShadow(view: averageRevenueView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: averageRevenueView.frame.size.width, height: 30)
        totalLabel.center.x = averageRevenueView.frame.size.width/2
        totalLabel.center.y = averageRevenueView.frame.size.height/3.5
        totalLabel.text = "Average $/Scan"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        averageRevenueView.addSubview(totalLabel)
        
        averageRevenueLabel.frame = CGRect(x: 0, y: 0, width: averageRevenueView.frame.size.width, height: 40)
        averageRevenueLabel.center.x = averageRevenueView.frame.size.width/2
        averageRevenueLabel.center.y = averageRevenueView.frame.size.height - averageRevenueView.frame.size.height/2.2
        averageRevenueLabel.textColor = .white
        averageRevenueLabel.font =  UIFont(name: "Poppins-Bold", size: 25)
        averageRevenueLabel.textAlignment = .center
        averageRevenueView.addSubview(averageRevenueLabel)
        setupShadow(view: totalLabel)
        
        
        
        
        
        
        parentView.addSubview(averageRevenueView)
        
        
    }
    
    
    
    
    
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





