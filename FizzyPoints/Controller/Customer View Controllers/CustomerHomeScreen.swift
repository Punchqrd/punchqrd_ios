//
//  CustomerHomeScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/25/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.


import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import GooglePlaces
import GoogleMaps


class CustomerHomeScreen : UIViewController, CLLocationManagerDelegate{
    
    var refresher : UIRefreshControl!
    var BusinessNamesArray : [BusinessName] = []
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var ScanScoreLabel: UILabel!
    @IBOutlet weak var BottomLabelView: UIView!
    @IBOutlet weak var BusinessList: UITableView!
    
    
    //MARK:- Preliminary setup
    
    func setupDefault() {
        defaults.set(GlobalVariables.ActualIDs.isLoggedIn, forKey: GlobalVariables.UserIDs.isUserLoggedIn)
    }
    
    
    func setupTitle() {
        self.navigationItem.title = Auth.auth().currentUser?.email!
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Thin", size: 15)!]
    }
    
    
    //MARK:- View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BusinessList.delegate = self
        navigationController?.navigationBar.shadowImage = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).as4ptImage()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.purple,
             NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 21)!]
        
        self.navigationItem.title = "fizzy points"
        refreshTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.refresher.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        self.qrButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.qrButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.2)
        self.qrButton.layer.shadowOpacity = 1.0
        self.qrButton.layer.shadowRadius = 0.0
        self.qrButton.layer.masksToBounds = false
        self.locationManager.delegate = self
        self.BusinessList.backgroundColor = .white
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = false
        GlobalVariables.ActualIDs.isLoggedIn = true
        self.setupDefault()
        showList()
        showScanScore()
        
    }
    
    
    //MARK:- Refresher functions
    
    //function to refresh the table view
    func refreshTableView() {
        //this is the refresh list variables to enable a refresh for the UITableView
        showScanScore()
        self.refresher = UIRefreshControl()
        refresher.tintColor = .white
        self.BusinessList.reloadData()
        self.refresher.addTarget(self, action: #selector(CustomerHomeScreen.refresh), for: UIControl.Event.valueChanged)
        self.BusinessList.addSubview(self.refresher)
        
        
    }
    
    @objc func refresh()
    {
        refreshData()
        self.refresher.endRefreshing()
        
    }
    
    //function to refresh the data on the page
    func refreshData() {
        showScanScore()
        let colorHolder : [UIColor] = [ .systemGreen, .yellow, .systemPurple, .brown, .orange]
        let randomColor = Int.random(in: 0...4)
        self.refresher.backgroundColor = colorHolder[randomColor].withAlphaComponent(0.8)
        self.BusinessList.reloadData()
        DispatchQueue.main.async { self.BusinessList.reloadData() }
        createBusinessList()
        BusinessList.dataSource = self
        BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        self.refresher.endRefreshing()
    }
    
    
    
    
    //MARK:- Table View logic
    
    //functuon to create a business list and show it on the screen
    func showList() {
        createBusinessList()
        showScanScore()
        BusinessList.dataSource = self
        BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        BusinessList.rowHeight = 100
    }
    
    
    //create a new list of business NAMES added (this list is according to the businesses the user added
    func createBusinessList() {
        BusinessNamesArray = []
        //access the database
        let db = Firestore.firestore()
        //specify the correct path to the collection set
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).getDocuments { (Businesses, error) in
            if let error = error {print(error)}
                
            else {
                for businessNames in Businesses!.documents {
                    //this is where you can add all the businesses to the tableview
                    let newBusinessAdded = BusinessName(inputName: businessNames.documentID, pointsAdded: businessNames.get(GlobalVariables.UserIDs.PointsString) as? Float ?? 0, redemptionCode: businessNames.get(GlobalVariables.UserIDs.RedemptionNumberString) as? Int ?? 0, bonusPoints: businessNames.get(GlobalVariables.UserIDs.BonusPointsString) as? Int ?? 0)
                    //add a new business to the array
                    print("\(newBusinessAdded.points) new points added")
                    
                    self.BusinessNamesArray.append(newBusinessAdded)
                    //setup this when reloading the data
                }
                self.BusinessList.reloadData()
            }
        }
    }
    
    
    //MARK:- Actions
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        logoutAlert(title: "Logout?", message: nil)
    }
    
    
    @IBAction func viewQRButton(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func searchBusinessButton(_ sender: UIBarButtonItem) {
        
        
    }
    
    
    
    //MARK:- Alerts
    
    //logout alert
    func logoutAlert(title : String?, message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
                //reset the values for the user defaults as false to indicate that the user is logged out
                GlobalVariables.ActualIDs.isLoggedIn = false
                self.defaults.set(GlobalVariables.ActualIDs.isLoggedIn, forKey: GlobalVariables.UserIDs.isUserLoggedIn)
                
                self.navigationController?.popToRootViewController(animated: false)
                
                
                print("Logged out the user")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true)
    }
    
    
    func createBottomAlert(title : String?, message : String?, valueRemove : Int, path : IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            GlobalFunctions.deleteBusinessFromCustomerCollection(nameOfFile: self.BusinessNamesArray[valueRemove].name)
            self.BusinessNamesArray.remove(at: valueRemove)
            self.BusinessList.deleteRows(at: [path], with: .fade)
            //insert the function to delete a piece of data from the collection
            self.BusinessList.reloadData()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true)
    }
    
    
    
    //MARK:- Supplimentary functions
    
    func showScanScore() {
        let db = Firestore.firestore()
        let customerScanData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerScanCollectionData).document(GlobalVariables.UserIDs.CustomerScanDocument)
        customerScanData.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                self.ScanScoreLabel.text = String(describing: doc.get(GlobalVariables.UserIDs.CustomerScanScore)!)
            } else {
                self.ScanScoreLabel.textColor = .red
                self.ScanScoreLabel.text = "0"
            }
        }
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
}

//MARK:-Extension for TableView

//extension for the uitable view data
extension CustomerHomeScreen: UITableViewDataSource, UITableViewDelegate {
    
    //how many cells should be present
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusinessNamesArray.count
    }
    
    //what will be show in each cell in the table view? : (name, points, progressbar updates, etc) Return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BusinessList.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID, for: indexPath) as! BusinessForCustomerCell
        let colorHolder : [UIColor] = [.blue, .green, .yellow, .cyan, .systemPurple, .magenta, .systemOrange, .purple, .systemTeal, .systemPink, .red]
        let randomColor = Int.random(in: 0...10)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        
        cell.PointsProgressBar.trackTintColor = UIColor.lightGray.withAlphaComponent(0.15)
        cell.BonusPointsLabel.textColor = colorHolder[randomColor]
        cell.BonusPointsLabel.isHidden = true
        cell.PerkString.isHidden = true
        cell.selectedBackgroundView = backgroundView
        cell.isUserInteractionEnabled = false
        cell.CheckMarkImage.isHidden = true
        cell.BusinessName.text = self.BusinessNamesArray[indexPath.row].name
        cell.PointsProgressBar.setProgress((self.BusinessNamesArray[indexPath.row].points/10), animated: true)
        cell.ActualPointsLabel.text = String((Int(self.BusinessNamesArray[indexPath.row].points)))
        cell.ActualPointsLabel.textColor = colorHolder[randomColor]
        
        GlobalFunctions.setPointProgressBarRadius(bar: cell.PointsProgressBar)
        
        
        if self.BusinessNamesArray[indexPath.row].bonusPoints != 0 {
            self.delay(0.2) {
                cell.BonusPointsLabel.isHidden = false
                if self.BusinessNamesArray[indexPath.row].bonusPoints == 10 {
                    cell.BonusPointsLabel.text = ("+10!")
                } else {
                    cell.BonusPointsLabel.text = ("+\(String(self.BusinessNamesArray[indexPath.row].bonusPoints))")
                }
            }
            self.delay(3.0) {
                cell.BonusPointsLabel.isHidden = true
                //show the bonus points, then delete them forever
                GlobalFunctions.deleteBonusPoint(user: Auth.auth().currentUser?.email, business: self.BusinessNamesArray[indexPath.row].name)
            }
        }
        
        
        if cell.PointsProgressBar.progress.isEqual(to: 1) {
            cell.CheckMarkImage.isHidden = false
            cell.animateCheckMark()
            cell.PointsProgressBar.tintColor = UIColor.green
            //cell.PerkString.isHidden = false
            let randomPerkStrings : [String] = ["You've got a perk!", "Scan to redeem!", "Grab your freebee!", "Go treat yourself!"]
            let randomNumber = Int.random(in: 0...8)
            let randomPerkString = Int.random(in: 0...3)
            if randomNumber > 6 {
                cell.PerkString.isHidden = false
                cell.PerkString.text = randomPerkStrings[randomPerkString]
            }
            
            
        }
        if cell.PointsProgressBar.progress.isEqual(to: 0) {
            let randomcolor2 = Int.random(in: 0...10)
            cell.PointsProgressBar.trackTintColor = colorHolder[randomcolor2].withAlphaComponent(0.20)
            
            cell.Points.isHidden = false
            cell.ActualPointsLabel.textColor = .black
        }
        
        
        return cell
        
        
    }
    
    
    //disable full swipe accross cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.createBottomAlert(title: "Remove this Business?", message: "All points will be lost", valueRemove: indexPath.row, path: indexPath)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
        
    }
    
    
}

//MARK:- Extension UIColor
extension UIColor {
    
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    func as4ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 6))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 6))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

