//
//  GlobalVariables.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation

//this class will be where all global variables will be stored and access for later use.
class GlobalVariables {
    
    
    //create a list of constants that can be used as ID's. All String Values.
    struct UserIDs {
        static let UserEmail = "User Email"
        static let UserPassword = "User Password"
        static let UserAddress = "User Address"
        static let UserName = "User Name"
        static let UserZipCode = "User ZipCode"
        static let UserCustomer = "Customer"
        static let UserOwner = "Owner"
        static let UserType = "User Type"
        static let CollectionTitle = "All Users"
        static let BusinessName = "Business Name"
        static let CustomerBusinessCollection = "Business Collection"
        static let PointsString =  "Points"
        static let CustomerTableViewCellID = "BusinessCell"
        static let CustomerNibCell = "BusinessForCustomerCell"
        static let RedemptionNumberString = "Redemption Number"
    }
    
    
    //list of variables that will be changed when the user updates his/her account info as he/she goes along the mprocess of registering.
    //these will be used in the Dictionary that will be passed into the data base at the very end of the process.
    struct ActualIDs {
        
        static var ActualEmail : String?
        static var ActualPassword : String?
        static var ActualUserType : String?
        static var ActualName : String?
        static var ActualZipCode : String?
        static var ActualAddress : String?
        static var ActualBusinessName : String?
        static var ActualAddedBusinessForCustomer : String?
        static var ActualIncrementedPoints : Int?
        static var ActualRedemptionNumber : Int?
        
        
        
        
    }
  
    
   
    
    
    //create a list of Segue IDs
    struct SegueIDs {
        
        //this is the customer register seque
        static let B_1RegisterSeque = "B_1RegisterSeque"
        //this is the business owner register segue
        static let B_2RegisterSeque = "B_2RegisterSeque"
        static let ToCustomerHomeScreen = "CustomerHomeScreen"
        static let ToOwnerHomeScreen =  "OwnerHomeScreen"
        static let RedemptionSegue = "RedemptionSegue"
           
       }
    
    
    
    
    
}
