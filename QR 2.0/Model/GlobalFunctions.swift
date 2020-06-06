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
        userCollection.document(employeeEmail!).setData([GlobalVariables.UserIDs.UserType : GlobalVariables.UserIDs.UserEmployee, GlobalVariables.UserIDs.EmployerString : GlobalVariables.ActualIDs.EmployerBusinessName!, GlobalVariables.UserIDs.EmployerNameString : GlobalVariables.ActualIDs.EmployerBusinessEmail])
        
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
    }
    
    static func deleteEmployeeAccessCode(codeValue : String?) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(codeValue!).delete()
                          { err in if let err = err {
                              print(err.localizedDescription)
                          } else {print("Deleted File")}}
              
    }
   
   
    
    
    
}
