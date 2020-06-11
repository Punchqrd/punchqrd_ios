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
import GooglePlaces
import GoogleMaps
import Lottie


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
    
    static func incrementPointValue(inputNumber : Int) -> Int{
        
        let random100 = Int.random(in: 1...50)
        if random100 >= 49 {
            return 10
        } else {
            if inputNumber == 1 {
                var value = Int.random(in: inputNumber...5)
                if value >= 10 {value = 9}
                return value
            }
            if inputNumber == 9 {
                return 1
            } else {
                var randomNumbers = Int.random(in: 1...3)
                if randomNumbers >= 10 {randomNumbers = 9}
                return randomNumbers
            }
        }
        
    }
    
    //increment the points of (name of business) for the (name of user) by 1.
    static func incrementPointsForUser (nameofUser : String?, nameofBusiness : String?,  totalPoints : Int?) {
        
        let db = Firestore.firestore()
        let finalValue = self.incrementPointValue(inputNumber: totalPoints!)
        let CustomerCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        CustomerCollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.BonusPointsString : finalValue])
        let Businesscollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(nameofUser!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection)
        Businesscollection.document(nameofBusiness!).updateData([GlobalVariables.UserIDs.PointsString : FieldValue.increment(Int64(finalValue))])
        
        
        
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
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.2)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5.0
       
        
        
        
    }
    
    static func setPointProgressBarRadius(bar : UIProgressView) {
        
        bar.layer.cornerRadius = 20
        bar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        bar.layer.shadowOffset = CGSize(width: 0.0, height: 0.4)
        bar.layer.shadowOpacity = 1.0
        bar.layer.shadowRadius = 0.0
        bar.layer.masksToBounds = false
        
        
        
    }
    
    static func deleteEmployeeAccessCode(codeValue : String?) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.employeeCodeCollection).document(codeValue!).delete()
            { err in if let err = err {
                print(err.localizedDescription)
            } else {print("Deleted File")}}
        
    }
    
    
    
    //increment the amount of times the user has scanned and other logic using code data
    //this can create more datadfields in other parts of the data base as needed. always make sure to check if if doc exists.
    static func incrementScanCountAndSetData(currentEmployee : String?, currentEmployerEmail : String?, userBeingScanned : String?) {
        let db = Firestore.firestore()
        let employerEmployeeCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!).collection(GlobalVariables.UserIDs.EmployeeList)
        //increment the total scans the user has done
        employerEmployeeCollection.document(currentEmployee!).updateData([GlobalVariables.UserIDs.TotalScansString : FieldValue.increment(Int64(1))])
        
        //create a branch collection for scan data (if it hasnt already been done) and add the userbeing scanned to the database along with total scans theyve receieved.
        let scanDataCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!).collection(GlobalVariables.UserIDs.EmployeeList)
        let employeeScanData = scanDataCollection.document(currentEmployee!).collection(GlobalVariables.UserIDs.ScanDataString).document(userBeingScanned!)
        //check if the user exists, if it does then skip this step, otherwise add him to the system.
        
        //IMPORTANT TO DO THIS EVERTYIME :)
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
        
        
        //create a new branch (if it already doesnt exist) to increment the total scans a business has done
        let employerTotalScanCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(currentEmployerEmail!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        
        employerTotalScanCollection.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                employerTotalScanCollection.updateData([GlobalVariables.UserIDs.CustomerPurchasesString : FieldValue.increment(Int64(1))])
            } else {
                employerTotalScanCollection.setData([GlobalVariables.UserIDs.CustomerPurchasesString : 1])
            }
        }
        
        
        //create a new branch (if it already doesnt exist) to increment the total scans a business has done
        let CustomerScanScoreCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(userBeingScanned!).collection(GlobalVariables.UserIDs.CustomerScanCollectionData).document(GlobalVariables.UserIDs.CustomerScanDocument)
        
        CustomerScanScoreCollection.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                CustomerScanScoreCollection.updateData([GlobalVariables.UserIDs.CustomerScanScore : FieldValue.increment(Int64(1))])
            } else {
                CustomerScanScoreCollection.setData([GlobalVariables.UserIDs.CustomerScanScore : 1])
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    static func deleteBonusPoint(user : String?, business : String?) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document(user!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(business!).updateData([GlobalVariables.UserIDs.BonusPointsString : 0])
        
    }
    
    
    
    static func employeeLocationForLogin(employeeEmployerBusinessName : String?, navigationController : UIViewController, errorLabel : UILabel!, animationView: AnimationView!) {
        print("calling function for location")
        let placesClient = GooglePlaces.GMSPlacesClient()
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList {
                    if likelihood.place.name != nil {
                        if String(describing: likelihood.place.name!) == employeeEmployerBusinessName! {
                            print("\(String(describing: likelihood.place.name!)) is a match with \(employeeEmployerBusinessName!)")
                            //if the business name is the same as the place.name
                            //check if the likelyhood of you being near the actual business is greate than 85%
                            if likelihood.likelihood > 0.85 {
                                //if you are near the business and are close enough, check if the business is open.
                                if likelihood.place.isOpen().rawValue == 1 {
                                    animationView.removeFromSuperview()
                                    navigationController.performSegue(withIdentifier: GlobalVariables.SegueIDs.EmployeeLoginSegue, sender: navigationController.presentingViewController)
                                    break
                                } else {
                                    
                                    errorLabel.text = "\(employeeEmployerBusinessName!) is closed"
                                    animationView.removeFromSuperview()
                                    break
                                }
                            } else {
                                
                                animationView.removeFromSuperview()
                                errorLabel.text = "Get closer to your business"
                                break
                            }
                            
                            
                        }//if the place is not a name
                            
                        else {
                            print("not the business")
                            
                            
                        }
                        
                        
                        
                        
                    }
                    else {
                        
                        animationView.removeFromSuperview()
                        errorLabel.text = "\(employeeEmployerBusinessName!) is not in your area"
                        break
                    }
                    
                    
                }
                
            }
        })
    }
    
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
