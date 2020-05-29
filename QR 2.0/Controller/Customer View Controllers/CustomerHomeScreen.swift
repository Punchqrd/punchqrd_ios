//
//  CustomerHomeScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/25/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import GooglePlaces
import GoogleMaps




class CustomerHomeScreen : UIViewController{
    
    //refresher variable
    var refresher : UIRefreshControl!
    //the created table view in the home screen
    @IBOutlet weak var BusinessList: UITableView!
    //the array created to hold business names and points the user has added to display to the tableview
    var BusinessNamesArray : [BusinessName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = false
        
        
        showList()
        //enabling the refreshing of the table view
        refreshTableView()
        
    }
    
    //functuon to create a business list and show it on the screen
    func showList() {
       
        createBusinessList()
        BusinessList.dataSource = self
        BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        BusinessList.rowHeight = 100
    }
    
    //function to refresh the table view
    func refreshTableView() {
        //this is the refresh list variables to enable a refresh for the UITableView
             self.refresher = UIRefreshControl()
             self.BusinessList.reloadData()
             self.refresher.addTarget(self, action: #selector(CustomerHomeScreen.refresh), for: UIControl.Event.valueChanged)
             self.BusinessList.addSubview(self.refresher)
              
    }
    
    @objc func refresh()
    {
        refreshData()
        self.BusinessList.reloadData()
        self.refresher.endRefreshing()
    
    }
   
    //function to refresh the data on the page
    func refreshData() {
        DispatchQueue.main.async { self.BusinessList.reloadData() }
        createBusinessList()
        BusinessList.dataSource = self
        BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
    }
    
    
  
    //add points button to add points to the user (TEMPORARY)
    //THIS is important. The business name of the business will have to be passed in through the employee
    @IBAction func AddPoints(_ sender: UIButton) {
        
        GlobalFunctions.incrementPointsForUser(nameofUser: Auth.auth().currentUser?.email, nameofBusiness: BusinessNamesArray[0].name) //this will have to change....to a unique business name
        self.BusinessList.reloadData()
        
        let db = Firestore.firestore()
        let businessCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email!)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(self.BusinessNamesArray[0].name)
        
        businessCollection.getDocument(source: .cache) { (redemptionPoint, error) in
         if let error = error { print(error.localizedDescription) }
         else {
            //fetch the pointsadded number from the document
            let data = redemptionPoint?.get(GlobalVariables.UserIDs.PointsString) as! Int
            
            //REDEMPTION NUMBER
            //if the number is either 10 or great, set the redemption point to 1 (meaning the user can redeem his code)
            if data >= 10 {GlobalFunctions.setRedemptionToTrue(nameofUser: Auth.auth().currentUser?.email, nameofBusiness: self.BusinessNamesArray[0].name)}
        }
        
    }
    }
    
    //this is also temporary
    @IBAction func DeletePoints(_ sender: UIButton) {
        GlobalFunctions.deleteAllPoints(nameofUser: Auth.auth().currentUser?.email, nameofBusiness: BusinessNamesArray[0].name) //the business name will have to be passed in from the logged in user
        GlobalFunctions.setRedemptionToFalse(nameofUser: Auth.auth().currentUser?.email, nameofBusiness: BusinessNamesArray[0].name)
        self.BusinessList.reloadData()
    }
    

    
    
    
    
    
    //create a new list of business NAMES added (this list is according to the businesses the user added
    func createBusinessList() {
        BusinessNamesArray = []
        //access the database
        let db = Firestore.firestore()
        //specify the correct path to the collection set
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).getDocuments(source: .cache) { (Businesses, error) in
            if let error = error {print(error)}
            
            else {
                for businessNames in Businesses!.documents {
                    //this is where you can add all the businesses to the tableview
                    let newBusinessAdded = BusinessName(inputName: businessNames.documentID, pointsAdded: businessNames.get(GlobalVariables.UserIDs.PointsString) as? Float ?? 0, redemptionCode: businessNames.get(GlobalVariables.UserIDs.RedemptionNumberString) as? Int ?? 0)
                    //add a new business to the array
                    self.BusinessNamesArray.append(newBusinessAdded)
                    //setup this when reloading the data
                    print(newBusinessAdded.name)
                }
                self.BusinessList.reloadData()
            }
        }
    }
      
    //button to open up the users QR Code
    @IBAction func ViewQR(_ sender: UIButton) {
        
        
    }
    
    //function to open up the search businesses page
    @IBAction func SearchBusinesses(_ sender: UIButton) {
        
        
    }
    
    //button action to logout the user
    @IBAction func LogoutButton(_ sender: UIBarButtonItem) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            //send the user back to the homescreen
            
            self.navigationController?.popToRootViewController(animated: true)
            print("Logged out the user")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }
    
    
}

//extension for the uitable view data
extension CustomerHomeScreen: UITableViewDataSource {
    
    //how many cells should be present
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this should be the actual lenght of the array
        return BusinessNamesArray.count
    }
    
    //what will be show in each cell in the table view? : (name, points, progressbar updates, etc) Return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BusinessList.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID, for: indexPath) as! BusinessForCustomerCell
        cell.CheckMarkImage.isHidden = true
        cell.BusinessName.text = self.BusinessNamesArray[indexPath.row].name
        cell.PointsProgressBar.setProgress((self.BusinessNamesArray[indexPath.row].points/10), animated: true)
        print(self.BusinessNamesArray[indexPath.row].points/10)
        cell.Points.text = String("\(Int(self.BusinessNamesArray[indexPath.row].points)):10")
        if cell.PointsProgressBar.progress.isEqual(to: 1) {
            cell.CheckMarkImage.isHidden = false
            cell.Points.isHidden = true
        }
        if cell.PointsProgressBar.progress.isEqual(to: 0) {
            cell.Points.isHidden = false
        }
        
        return cell
        
    }
    
    //function to remove data from a cell, and to swipe to delete the cell from the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GlobalFunctions.deleteBusinessFromCustomerCollection(nameOfFile: BusinessNamesArray[indexPath.row].name)
            BusinessNamesArray.remove(at: indexPath.row)
            BusinessList.deleteRows(at: [indexPath], with: .fade)
            //insert the function to delete a piece of data from the collection
            self.BusinessList.reloadData()
        }
        
    }
    
   
    
    
    
    
    

    
    
    
    
}
