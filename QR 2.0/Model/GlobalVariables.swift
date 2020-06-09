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
        static let UserEmployee = "Employee"
        static let UserType = "User Type"
        static let CollectionTitle = "All Users"
        static let BusinessName = "Business Name"
        static let CustomerBusinessCollection = "Business Collection"
        static let PointsString =  "Points"
        static let CustomerTableViewCellID = "BusinessCell"
        static let EmployeeTableCellID = "EmployeeCell"
        static let EmployeeNibCellID = "EmployeeCell"
        static let CustomerNibCell = "BusinessForCustomerCell"
        static let RedemptionNumberString = "Redemption Number"
        static let EmployeeList = "Employees"
        static let UserDeletedType = "Deleted"
        static let EmployerString = "Employer"
        static let TotalScansString = "Total Scans"
        static let ScanDataString = "Scan Data"
        static let ScansRecievedString = "Times Scanned"
        static let TotalCustomerScannedString = "Total Times Scanned"
        static let CustomersScannedCollectionTitle = "Customers"
        static let CustomerPurchasesString = "Total Purchases"
        static let BonusPointsString = "Bonus Points"
        static let CustomerScanScore = "Scan Score"
        static let CustomerScanCollectionData = "Scan Collection"
        static let CustomerScanDocument = "Scan Data"
        
        
        
        
        static let UserCodeString = "Code"
        //THIS is the title of the business access code collection for firebase.
        static let AccessCodeCollectionTitle = "Business Access Codes"

        static let EmployeeEmailString = "Employee Email"
        static let EmployeePasswordString = "Password"
        static let EmployeeNameString = "Name"
        
        
        //employee codes
        static let employeeCodeCollection = "Employee Access Codes"
        static let EmployerNameString = "Employer Email"
        static let EmployerBusinessString = "Employer Business"
        
        //user default ids
        static let isUserLoggedIn = "Logged In"
    }
    
    
    //list of variables that will be changed when the user updates his/her account info as he/she goes along the mprocess of registering.
    //these will be used in the Dictionary that will be passed into the data base at the very end of the process.
    struct ActualIDs {
        
        static var CurrentUser : String?
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
        static var ActualEmployeeEmail : String?
        static var ActualEmployeePassword : String?
        static var ActualEmployeeName : String?
        static var EmployerBusinessName : String?
        static var EmployerBusinessEmail : String?
        static var ActualCustomer : String?
        static var CurrentNameofBusiness : String?
        
        
     
        
        //the random value generated from the qr code on the customers screen
        static var userCustomerCode : String?
        
        //the value read from the qr code scanner
        static var ActualQRData : String?
        
       //access code given by the employer
        static var employeeAccessCode : String?
        
    
        //user default is the user logged in boolean
        static var isLoggedIn = false
        
        
    }
  
    
   
    
    
    //create a list of Segue IDs
    struct SegueIDs {
        
        static let B_1RegisterSeque = "B_1RegisterSeque"
        static let B_2RegisterSeque = "B_2RegisterSeque"
        static let ToCustomerHomeScreen = "CustomerHomeScreen"
        static let ToOwnerHomeScreen =  "OwnerHomeScreen"
        static let RedemptionSegue = "RedemptionSegue"
        static let EmployeeAddScreenSegue = "EmployeeAddScreenSegue"
        static let EmployeeLoginSegue = "EmployeeLoginSegue"
        static let AddPointsScreeSegue = "AddPointsToEmployeeSegue"
        static let AccessCodeSuccessSegue = "AccessCodeSuccess"
        static let PostBusinessSearchSegue = "PostBusinessSearch"
        static let EmployeeSecondScreenSegue = "AddEmployee2Segue"
        static let FinalEmployeeRegisterSegue = "FinalEmployeeRegisterSegue"
        static let RedemptionConfirmSegue = "RedemptionSegue"
        static let toLoginScreen = "toLoginScreen"
        static let toCameraScreen = "CameraSegue"
           
       }
    
    
    
    
    
}
