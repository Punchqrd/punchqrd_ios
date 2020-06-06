//
//  GlobalFunctions.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/25/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


class GlobalFunctions {
    
    
    //function to delete input data field from BusinessCollection
    static func deleteBusinessFromCustomerCollection(nameOfFile : String?) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(nameOfFile!).delete()
            { err in if let err = err {
                print(err.localizedDescription)
            } else {print("Deleted File")}}
    }
    
    static func deleteEmployeeFromBusiness(nameOfFile : String?){
        let db = Firestore.firestore()
        
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameOfFile!).updateData([GlobalVariables.UserIDs.UserType : GlobalVariables.UserIDs.UserDeletedType])
        
        
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.EmployeeList).document(nameOfFile!).delete()
            { err in if let err = err {
                print(err.localizedDescription)
            } else {print("Deleted File")}}
        
        
    }
    
    
    //increment the points of (name of business) for the (name of user) by 1.
    static func incrementPointsForUser (nameofUser : String?, nameofBusiness : String?) {
        let db = Firestore.firestore()
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.PointsString : FieldValue.increment(Int64(1))])
    }
    
    //global function to delete all the points from the users (nameofUser) data base Business input as (nameofbusiness)
    static func deleteAllPoints (nameofUser : String?, nameofBusiness : String?) {
        let db = Firestore.firestore()
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.PointsString : 0])
        
    }
    
    //set the redemption number to 1. This means the use has enabled a redemption reward. 
    static func setRedemptionToTrue (nameofUser : String?, nameofBusiness : String?) {
        let db = Firestore.firestore()
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.RedemptionNumberString : 1])
        
    }
    //reset redemption points to nothing once the user has redeemed his/her points
    static func setRedemptionToFalse (nameofUser : String?, nameofBusiness : String?) {
        let db = Firestore.firestore()
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.RedemptionNumberString : 0])
        
    }
    //add an employee to the list of employees with respective shifts
    static func addEmployee (nameofUser : String?, employeeName : String?, employeeEmail : String?, employeePassword : String?) {
        let db = Firestore.firestore()
        print(nameofUser!)
        //this makes a new collection of employees, if it already hasnt been
        let Employeecollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.EmployeeList)
        //set details of user ID's in the employee field
        Employeecollection.document(employeeEmail!).setData([GlobalVariables.UserIDs.EmployeeNameString : employeeName!, GlobalVariables.UserIDs.EmployeePasswordString : employeePassword!, GlobalVariables.UserIDs.UserType : GlobalVariables.UserIDs.UserEmployee])
        
        let userCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle)
        userCollection.document(employeeEmail!).setData([GlobalVariables.UserIDs.UserType : GlobalVariables.UserIDs.UserEmployee, GlobalVariables.UserIDs.EmployerString : GlobalVariables.ActualIDs.EmployerBusinessName!, GlobalVariables.UserIDs.EmployerNameString : GlobalVariables.ActualIDs.EmployerBusinessEmail!])
        
    }
    
    static func appendRandomCode(customerEmail : String?, codeValue : String?) {
        let db = Firestore.firestore()
        let userData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(customerEmail!)
        userData.updateData([GlobalVariables.UserIDs.UserCodeString : GlobalVariables.ActualIDs.userCustomerCode!])
    }
    
    static func resetCode(customerEmail : String?, codeValue : String?) {
        let db = Firestore.firestore()
        let userData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(customerEmail!)
        userData.updateData([GlobalVariables.UserIDs.UserCodeString : codeValue!])
        
    }
    
    static func setButtonRadius(button : UIButton) {
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5.0
        
        
        
    }
   
    
    static func deleteEmployeeAccessCode(codeValue : String?) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(codeValue!).delete()
            { err in if let err = err {
                print(err.localizedDescription)
            } else {print("Deleted File")}}
        
    }
    
    //increment the amount of times the user has scanned and other logic using co
    static func incrementScanCountAndSetData(currentEmployee : String?, currentEmployerEmail : String?, userBeingScanned : String?) {
        let db = Firestore.firestore()
        let employerEmployeeCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!).collection(GlobalVariables.UserIDs.EmployeeList)
        //increment the total scans the user has done
        employerEmployeeCollection.document(currentEmployee!).updateData([GlobalVariables.UserIDs.TotalScansString : FieldValue.increment(Int64(1))])
        
        //create a branch collection for scan data (if it hasnt already been done) and add the userbeing scanned to the database along with total scans theyve receieved.
        let scanDataCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!).collection(GlobalVariables.UserIDs.EmployeeList)
        let employeeScanData = scanDataCollection.document(currentEmployee!).collection(GlobalVariables.UserIDs.ScanDataString).document(userBeingScanned!)
        //check if the user exists, if it does then skip this step, otherwise add him to the system.
        employeeScanData.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                employeeScanData.updateData([GlobalVariables.UserIDs.ScansRecievedString : FieldValue.increment(Int64(1))])
            } else {
                employeeScanData.setData([GlobalVariables.UserIDs.ScansRecievedString : 1])
            }
        }
        //create a new branch collection for the business owner to add scanned customers.
        let employerBusiness = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!)
        let employerUsersScannedData = employerBusiness.collection(GlobalVariables.UserIDs.CustomersScannedCollectionTitle).document(userBeingScanned!)
        employerUsersScannedData.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                employerUsersScannedData.updateData([GlobalVariables.UserIDs.ScansRecievedString : FieldValue.increment(Int64(1))])
            } else {
                employerUsersScannedData.setData([GlobalVariables.UserIDs.ScansRecievedString : 1])
            }
        }
            
            
        
        print(userBeingScanned!)
    }
    
    
    
    
    
}
