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
        static let CustomerNibCell = "BusinessForCustomerCell"
        static let RedemptionNumberString = "Redemption Number"
        static let EmployeeList = "Employees"
        static let EmployeeShiftCollection = "Employee Shifts"
        static let DateViewCellForEmployeeID = "DatesCell"
        static let ShiftCellObjectTitle = "ShiftCellObject"
        static let EmployeeDateCelltitle = "EmployeeDatecell"
        static let daysofWeekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        static let startStringTime = "Start Time"
        static let endStringTime = "End Time"
        
        //employee strings
        static let mondayString = "Monday"
        static let tuesdayString = "Tuesday"
        static let wednesdayString = "Wendesday"
        static let thursdayString = "Thursday"
        static let fridayString = "Friday"
        static let saturdayString = "Saturday"
        static let sundayString = "Sunday"
        
        static let mondayStartTimeString = "Start"
        static let mondayEndTimeString = "End"
        static let tuesdayStartTimeString = "Start"
        static let tuesdayEndTimeString = "End"
        static let wednesdayStartTimeString = "Start"
        static let wednesdayEndTimeString = "End"
        static let thursdayStartTimeString = "Start"
        static let thursdayEndTimeString = "End"
        static let fridayStartTimeString = "Start"
        static let fridayEndTimeString = "End"
        static let saturdayStartTimeString = "Start"
        static let saturdayEndTimeString = "End"
        static let sundayStartTimeString = "Start"
        static let sundayEndTimeString = "End"

        static let EmployeeEmailString = "Employee Email"
        static let EmployeePasswordString = "Password"
        static let EmployeeNameString = "Name"

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
        
        
        //employee variables to check whether days have been picked
        static var mondayIsOn : Bool?
        static var tuesdayIsOn : Bool?
        static var wednesdayIsOn : Bool?
        static var thursdayIsOn : Bool?
        static var fridayIsOn : Bool?
        static var saturdayIsOn : Bool?
        static var sundayIsOn : Bool?

        //adding an nsdate for each day
        static var mondayStartTime : String?
        static var mondayEndTime : String?
        static var tuesdayStartTime : String?
        static var tuesdayEndTime : String?
        static var wednesdayStartTime : String?
        static var wednesdayEndTime : String?
        static var thursdayStartTime : String?
        static var thursdayEndTime : String?
        static var fridayStartTime : String?
        static var fridayEndTime : String?
        static var saturdayStartTime : String?
        static var saturdayEndTime : String?
        static var sundayStartTime : String?
        static var sundayEndTime : String?
        
        
    }
  
    
   
    
    
    //create a list of Segue IDs
    struct SegueIDs {
        
        static let B_1RegisterSeque = "B_1RegisterSeque"
        static let B_2RegisterSeque = "B_2RegisterSeque"
        static let ToCustomerHomeScreen = "CustomerHomeScreen"
        static let ToOwnerHomeScreen =  "OwnerHomeScreen"
        static let RedemptionSegue = "RedemptionSegue"
        static let EmployeeAddScreenSegue = "EmployeeAddScreenSegue"
           
       }
    
    
    
    
    
}
