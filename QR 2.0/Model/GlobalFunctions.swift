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
    
    static func setRedemptionToFalse (nameofUser : String?, nameofBusiness : String?) {
        let db = Firestore.firestore()
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.RedemptionNumberString : 0])

    }
    
    
   
    
    
    
}
