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
    let viewFeedButton = UIButton()
    let BusinessList = UITableView()
    
    //MARK:- Preliminary setup
    
    func setupDefault() {
        defaults.set(GlobalVariables.ActualIDs.isLoggedIn, forKey: GlobalVariables.UserIDs.isUserLoggedIn)
    }
    
    
 
    
    //MARK:- View functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .systemPurple
        navigationController?.navigationBar.prefersLargeTitles = false
        BusinessList.delegate = self
        navigationController?.navigationBar.shadowImage = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).as4ptImage()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
        
        self.navigationItem.title = "Your Subscriptions"
        refreshTableView()
        setupSideButton()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes =
                   [NSAttributedString.Key.foregroundColor: UIColor.black,
                    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
               
        self.navigationItem.title = "Your Subscriptions"
        self.refresher.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        self.qrButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.qrButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.2)
        self.qrButton.layer.shadowOpacity = 1.0
        self.qrButton.layer.shadowRadius = 0.0
        self.qrButton.layer.cornerRadius = qrButton.frame.size.width/2
        
        self.locationManager.delegate = self
        self.BusinessList.backgroundColor = .white
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = false
        

        GlobalVariables.ActualIDs.isLoggedIn = true
        self.setupDefault()
        showList()
        setupTable()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .systemPurple
        
        //swipe gestures
        let viewNewsFeedGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapSideButton))
        viewNewsFeedGesture.direction = .right
        self.view.addGestureRecognizer(viewNewsFeedGesture)
        
        
    }
    
    
    
    //MARK:- Refresher functions
    
    //function to refresh the table view
    func refreshTableView() {
        //this is the refresh list variables to enable a refresh for the UITableView
       
        self.refresher = UIRefreshControl()
        refresher.tintColor = .white
        self.refresher.addTarget(self, action: #selector(CustomerHomeScreen.refresh), for: UIControl.Event.valueChanged)
        self.BusinessList.addSubview(self.refresher)
        
        
    }
    
    @objc func refresh()
    {
        //calls the function below
        
        refreshData()
        
    }
    
   
    
    //function to refresh the data on the page
    func refreshData() {
      
       
        let colorHolder : [UIColor] = [.systemPurple]
        let randomColor = 0
        self.refresher.backgroundColor = colorHolder[randomColor].withAlphaComponent(0.8)
        
        //self.BusinessList.reloadData()
        DispatchQueue.main.async {
            self.createBusinessList()
            self.BusinessList.reloadData()
            self.BusinessList.dataSource = self
            self.BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
            //find a way to end the refreshing when the internet is back on.
            
            
        }
        

    }
    
    
    
    
    //MARK:- Table View logic and Setup
    
    func setupSideButton() {
        let containerForButton = UIView()
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerForButton)
        self.view.bringSubviewToFront(containerForButton)
        containerForButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.layer.cornerRadius = 35
        containerForButton.backgroundColor = .systemPurple
        containerForButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        containerForButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -35).isActive = true
        containerForButton.layer.shadowColor = UIColor.lightGray.cgColor
        containerForButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerForButton.layer.shadowRadius = 10
        containerForButton.layer.shadowOpacity = 0.3
        
        
        
        
        let backGroundImage = UIImage(systemName: "chevron.right")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        containerForButton.addSubview(viewFeedButton)
        containerForButton.bringSubviewToFront(viewFeedButton)
        viewFeedButton.translatesAutoresizingMaskIntoConstraints = false
        viewFeedButton.setImage(tintedImage, for: .normal)
        viewFeedButton.tintColor = .white
        viewFeedButton.backgroundColor = .clear
        viewFeedButton.addTarget(self, action: #selector(didTapSideButton), for: .touchUpInside)
        viewFeedButton.rightAnchor.constraint(equalTo: containerForButton.rightAnchor, constant: -15).isActive = true
        viewFeedButton.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor, constant: 0).isActive = true
        
        
        
        
    }
    
    func setupTable() {
        BusinessList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(BusinessList)
        BusinessList.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        BusinessList.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
        BusinessList.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        BusinessList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        BusinessList.layer.shadowColor = UIColor.black.cgColor
        BusinessList.layer.shadowOffset = CGSize(width: 0, height: 0)
        BusinessList.layer.shadowRadius = 10
        BusinessList.layer.shadowOpacity = 0.3
        BusinessList.separatorStyle = .none
        self.view.sendSubviewToBack(BusinessList)
    }
    //functuon to create a business list and show it on the screen
    func showList() {
        createBusinessList()
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
                    let newBusinessAdded = BusinessName(inputName: businessNames.documentID, pointsAdded: businessNames.get(GlobalVariables.UserIDs.PointsString) as? Float ?? 0, redemptionCode: businessNames.get(GlobalVariables.UserIDs.RedemptionNumberString) as? Int ?? 0, bonusPoints: businessNames.get(GlobalVariables.UserIDs.BonusPointsString) as? Int ?? 0, address: businessNames.get(GlobalVariables.UserIDs.UserAddress) as! String)
                    //add a new business to the array
                    
                    self.BusinessNamesArray.append(newBusinessAdded)
                    //setup this when reloading the data
                }
                self.BusinessList.reloadData()
                self.refresher.endRefreshing()            }
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
    
    @objc func didTapSideButton() {
        let promoteScreen = Customer_Feed()
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(promoteScreen, animated: false)
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
            GlobalFunctions.deleteBusinessFromCustomerCollection(nameOfFile: self.BusinessNamesArray[valueRemove].name, address: self.BusinessNamesArray[valueRemove].address)
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
        cell.PointsProgressBar.trackTintColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.PointsProgressBar.setProgress((self.BusinessNamesArray[indexPath.row].points/10), animated: true)
//        cell.PointsProgressBar.progressTintColor = UIColor(red: 123, green: 0, blue: 146)
        cell.PointsProgressBar.progressTintColor = UIColor.systemPurple
        
     
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        cell.BonusPointsLabel.textColor = .white
        cell.bonusPointsCircle.isHidden = true
      
        cell.ActualPointsLabel.text = String((Int(self.BusinessNamesArray[indexPath.row].points)))
        cell.ActualPointsLabel.textColor = UIColor.white
        
        
        cell.isUserInteractionEnabled = true
        cell.CheckMarkImage.isHidden = true
        cell.BusinessName.text = self.BusinessNamesArray[indexPath.row].name
        
//        GlobalFunctions.setPointProgressBarRadius(bar: cell.PointsProgressBar)
        
        
        if self.BusinessNamesArray[indexPath.row].bonusPoints != 0 {
            self.delay(0.2) {
                cell.bonusPointsCircle.isHidden = false
                cell.BonusPointsLabel.text = String(describing: self.BusinessNamesArray[indexPath.row].bonusPoints)
//                cell.bonusPointsCircle.sendSubviewToBack(cell.BonusPointsLabel)

              
            }
            self.delay(3.0) {
                cell.bonusPointsCircle.isHidden = true
                //show the bonus points, then delete them forever
                
                //this is a little buggy when one or more business are added to the users profile
                //could be connectivity issues.?
                GlobalFunctions.deleteBonusPoint(user: Auth.auth().currentUser?.email, business: self.BusinessNamesArray[indexPath.row].name)
            }
        }
        
        
        if cell.PointsProgressBar.progress.isEqual(to: 1) {
            cell.CheckMarkImage.isHidden = false
            cell.animateCheckMark()
            cell.PointsProgressBar.progressTintColor = UIColor.systemGreen
        } else {
            cell.pointsCircle.backgroundColor = .systemIndigo
            cell.ActualPointsLabel.isHidden = false
        }
        
        
        
       
        
        return cell
       
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = Firestore.firestore()
        let businessCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(BusinessNamesArray[indexPath.row].name)
        
        businessCollection.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                
                let totalSpent = doc.get(GlobalVariables.UserIDs.CustomerTotalSpent) as? Double ?? 0
                let totalScans = doc.get(GlobalVariables.UserIDs.CustomerScanDocument) as? Int ?? 0
                
                let newView = Info_BusinessCustomer(parentView: self.view, totalSpent: totalSpent.rounded(toPlaces: 2), totalScans: totalScans, nameOfBusiness: self.BusinessNamesArray[indexPath.row].name)
                newView.setupView()

        }
        }
            
      
        
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

