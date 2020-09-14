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
import UserNotifications



class CustomerHomeScreen : UIViewController, CLLocationManagerDelegate, InstructionalPageProtocol{
    
    
    var didViewInstructionDec = false
    var refresher : UIRefreshControl!
    var BusinessNamesArray : [BusinessName] = []
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    let current = UNUserNotificationCenter.current()
    let instructionalViewController = InstructionalPage()
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    let qrButton = ActionButton(backgroundColor: Global_Colors.colors.apricot, title: "[  ]", image: nil)
    
    let viewFeedButton = UIButton()
    let BusinessList = UITableView()
    
    let businessCollection = Firestore.firestore()
    
    var delegate : BusinessSearchProtocol?
    
    //MARK:- Preliminary setup
    
    func setupDefault() {
        defaults.set(GlobalVariables.ActualIDs.isLoggedIn, forKey: GlobalVariables.UserIDs.isUserLoggedIn)
    }
    
    
    
    
    //MARK:- View functions
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        //calling the methods that will ask the user for their token id.
        registerForPushNotifications()
        
        
        
        
        
        
        
        view.backgroundColor = Global_Colors.colors.mainQRButtonColor
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        
        
        
        
        navigationController?.navigationBar.prefersLargeTitles = false
        BusinessList.delegate = self
        navigationController?.navigationBar.shadowImage = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).as4ptImage()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 26)!]
        
        self.navigationItem.title = "Your Spots"
        refreshTableView()
        setupSideButton()
        setupQRButton()
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false

        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 26)!]
        navigationController?.navigationBar.barTintColor = .white
        
        self.navigationItem.title = "Your Spots"
        self.refresher.backgroundColor = .white
        
        
        
        self.locationManager.delegate = self
        self.BusinessList.backgroundColor = .white
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = false
        
        
        GlobalVariables.ActualIDs.isLoggedIn = true
        self.setupDefault()
        showList()
        setupTable()
        
        
        
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
        refresher.tintColor = .lightGray
        self.refresher.addTarget(self, action: #selector(CustomerHomeScreen.refresh), for: UIControl.Event.valueChanged)
        self.BusinessList.addSubview(self.refresher)
        self.refresher.backgroundColor = .white
        
    }
    
    @objc func refresh()
    {
        //calls the function below
        
        refreshData()
        
    }
    
    
    
    //function to refresh the data on the page
    func refreshData() {
        
        print(self.view.frame.size.height)
        
        self.refresher.backgroundColor = .white
        //dispatch queue call
        DispatchQueue.main.async {
            self.createBusinessList()
            self.BusinessList.reloadData()
            self.BusinessList.dataSource = self
            self.BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        }
        
    }
    
    
    
    
    //MARK:- View
    
    //qr button setup
    func setupQRButton() {
        view.addSubview(qrButton)
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        qrButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        qrButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        qrButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        qrButton.addTarget(self, action: #selector(viewQRButton), for: .touchUpInside)
        
        qrButton.layer.shadowColor = UIColor.gray.cgColor
        qrButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        qrButton.layer.shadowRadius = 8
        qrButton.layer.shadowOpacity = 0.4
        
        
        view.bringSubviewToFront(qrButton)
        
    }
    
    
    
    //side button setup
    private func setupSideButton() {
        let containerForButton = UIView()
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerForButton)
        self.view.bringSubviewToFront(containerForButton)
        containerForButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.layer.cornerRadius = 35
        containerForButton.backgroundColor = .clear
        containerForButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        containerForButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -35).isActive = true
        
        
        
        
        
        
        let backGroundImage = UIImage(systemName: "chevron.right")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        containerForButton.addSubview(viewFeedButton)
        containerForButton.bringSubviewToFront(viewFeedButton)
        viewFeedButton.translatesAutoresizingMaskIntoConstraints = false
        viewFeedButton.setImage(tintedImage, for: .normal)
        viewFeedButton.tintColor = .black
        viewFeedButton.backgroundColor = .clear
        viewFeedButton.addTarget(self, action: #selector(didTapSideButton), for: .touchUpInside)
        viewFeedButton.rightAnchor.constraint(equalTo: containerForButton.rightAnchor, constant: -15).isActive = true
        viewFeedButton.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor, constant: 0).isActive = true
        
        
        
        
    }
    
    private func setupTable() {
        BusinessList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(BusinessList)
        BusinessList.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        BusinessList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        BusinessList.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        BusinessList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        BusinessList.layer.shadowColor = UIColor.black.cgColor
        BusinessList.layer.shadowOffset = CGSize(width: 0, height: 0)
        BusinessList.layer.shadowRadius = 10
        BusinessList.layer.shadowOpacity = 0.3
        BusinessList.separatorStyle = .none
        view.sendSubviewToBack(BusinessList)
    }
    //functuon to create a business list and show it on the screen
    private func showList() {
        createBusinessList()
        BusinessList.dataSource = self
        guard BusinessNamesArray.isEmpty else {return}
        BusinessList.register(BusinessForCustomerCell.self, forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        //        BusinessList.register(UINib(nibName: GlobalVariables.UserIDs.CustomerNibCell, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.CustomerTableViewCellID)
        BusinessList.rowHeight = 100
        
    }
    
    
    //create a new list of business NAMES added (this list is according to the businesses the user added
    func createBusinessList() {
        BusinessNamesArray = []
        //access the database
        let db = Firestore.firestore()
        //specify the correct path to the collection set
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).getDocuments { (Businesses, error) in
            if let error = error {print(error)
                return
                
            }
                
            else {
                for businessNames in Businesses!.documents {
                    //this is where you can add all the businesses to the tableview
                    
                    //call the listener function
                    
                    
                    
                    
                    
                    
                    let newBusinessAdded = BusinessName(inputName: businessNames.documentID, pointsAdded: businessNames.get(GlobalVariables.UserIDs.PointsString) as? Float ?? 0, redemptionCode: businessNames.get(GlobalVariables.UserIDs.RedemptionNumberString) as? Int ?? 0, bonusPoints: businessNames.get(GlobalVariables.UserIDs.BonusPointsString) as? Int ?? 0, address: businessNames.get(GlobalVariables.UserIDs.UserAddress) as! String)
                    //add a new business to the array
                    
                    self.BusinessNamesArray.append(newBusinessAdded)
                    //setup this when reloading the data
                }
                self.BusinessList.reloadData()
                if self.BusinessNamesArray.isEmpty && self.didViewInstructionDec == false {
                    
                    let navigationController = self.navigationController
                    let transition = CATransition()
                    transition.duration = 0.2
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    transition.type = CATransitionType.moveIn
                    transition.subtype = CATransitionSubtype.fromTop
                    navigationController?.view.layer.add(transition, forKey: nil)
                    self.instructionalViewController.delegate = self
                    navigationController?.pushViewController(self.instructionalViewController, animated: false)
                    
                }
                
                
                
                
                
                //                Setting up the listener for each business for any sort of notification.
                //                DispatchQueue.main.async {
                //                    for values in self.BusinessNamesArray {
                //                        self.setupListener(businessAddress: values.address) { (businessName) in
                //                            let content = UNMutableNotificationContent()
                //                            content.title = "\(values.name.self)"
                //                            content.subtitle = "Just updated their feed."
                //                            content.sound = UNNotificationSound.default
                //
                //                            // show this notification five seconds from now
                //                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                //
                //                            // choose a random identifier
                //                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                //
                //                            // add our notification request
                //                            UNUserNotificationCenter.current().add(request)
                //
                //                            let alert = UIAlertController(title: "\(values.name) just posted.", message: nil, preferredStyle: .alert)
                //                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                //
                //                                Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(values.address).collection(GlobalVariables.UserIDs.subscriberCollection).document((Auth.auth().currentUser?.email)!).updateData([GlobalVariables.UserIDs.recieveAlerts : false])
                //
                //                                return
                //
                //                            }))
                //                            self.present(alert, animated: true, completion: nil)
                //                        }
                //                    }
                //                }
                
                
                self.refresher.endRefreshing()            }
        }
    }
    
    //MARK:- Protocol Declarations
    func didViewInstructions() {
        didViewInstructionDec = true
    }
    
    
    //MARK:- Actions
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        logoutAlert(title: "Logout?", message: nil)
    }
    
    
    @objc func viewQRButton() {
        let qrCodeScreen = QRView()
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(qrCodeScreen, animated: false)
        
    }
    
    
    @IBAction func searchBusinessButton(_ sender: UIBarButtonItem) {
        let promoteScreen = BusinessSearch()
        //        promoteScreen.delegate = self
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(promoteScreen, animated: false)
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
        cell.parentView = self.view
        cell.PointsProgressBar.trackTintColor = .white //UIColor.systemGray6.withAlphaComponent(0.3)
        cell.PointsProgressBar.setProgress((self.BusinessNamesArray[indexPath.row].points/10), animated: true)
        cell.PointsProgressBar.progressTintColor = Global_Colors.colors.apricot
        //random colors for the points
        let randomNumber = Int.random(in: 0...1)
        let randomColorArray = [Global_Colors.colors.puncchardColor1, Global_Colors.colors.puncchardColor2]
        cell.pointsCircle.backgroundColor = randomColorArray[randomNumber]
        
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        cell.BonusPointsLabel.textColor = .white
        cell.bonusPointsCircle.isHidden = true
        
        cell.ActualPointsLabel.text = String((Int(self.BusinessNamesArray[indexPath.row].points)))
        cell.ActualPointsLabel.textColor = .gray
        
        
        cell.isUserInteractionEnabled = true
        cell.CheckMarkImage.isHidden = true
        cell.BusinessName.text = self.BusinessNamesArray[indexPath.row].name
        cell.BusinessName.numberOfLines = 0
        
        //        if self.BusinessNamesArray[indexPath.row].points == 0 {
        //            cell.PointsProgressBar.trackTintColor = .clear
        //        }
        
        if self.BusinessNamesArray[indexPath.row].bonusPoints != 0 {
            self.delay(0.1) {
                print(self.BusinessNamesArray[indexPath.row].bonusPoints)
                
                //the user will see this notification when recieving a bonus point.
                let content = UNMutableNotificationContent()
                content.subtitle = "+\(String(describing: self.BusinessNamesArray[indexPath.row].bonusPoints))"
                content.title = "\(String(describing: self.BusinessNamesArray[indexPath.row].name))"
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                let notificationCenter = UNUserNotificationCenter.current()
                // add our notification request
                notificationCenter.add(request)
                
                cell.bonusPointsCircle.isHidden = false
                cell.BonusPointsLabel.text = "+\(String(describing: self.BusinessNamesArray[indexPath.row].bonusPoints))"
                cell.BonusPointsLabel.textColor = .systemGray3
                
                
            }
            self.delay(3.0) {
                cell.bonusPointsCircle.isHidden = true
                
                GlobalFunctions.deleteBonusPoint(user: Auth.auth().currentUser?.email, business: self.BusinessNamesArray[indexPath.row].name)
            }
        }
        
        
        if cell.PointsProgressBar.progress.isEqual(to: 1) {
            cell.CheckMarkImage.isHidden = false
            cell.animateCheckMark()
            cell.PointsProgressBar.progressTintColor = .systemGreen
        } else {
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
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.createBottomAlert(title: "Remove this Business?", message: "All points will be lost", valueRemove: indexPath.row, path: indexPath)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
        
    }
    
    
}















//
////MARK:- Business Search Protocol Extension
//extension CustomerHomeScreen: BusinessSearchProtocol {
//    
//    ///this again is just a test function that is used to see if the protocol is actually doing its job.
//    func printThisTest(value: String) {
//        print(value)
//    }
//    
//    
//    
//    
//    func isListening(BusinessName: String, businessAddress: String) {
//        
//        print("this is being called")
//        setupListener(businessAddress: businessAddress) { (didChangeValue) in
//            
//            let content = UNMutableNotificationContent()
//            content.title = "\(BusinessName)"
//            content.subtitle = "Just updated their feed."
//            content.sound = UNNotificationSound.default
//       
//            // show this notification five seconds from now
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//            
//            // choose a random identifier
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            
//            // add our notification request
//            UNUserNotificationCenter.current().add(request)
//            
//            let alert = UIAlertController(title: "Added: \(BusinessName)", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
//                
//                Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(businessAddress).collection(GlobalVariables.UserIDs.subscriberCollection).document((Auth.auth().currentUser?.email)!).updateData([GlobalVariables.UserIDs.recieveAlerts : false])
//                
//                return
//                
//            }))
//            self.present(alert, animated: true, completion: nil)
//            
//            
//        }
//    }
//    
//    
//    
//    
//    //setup the listener function to return a value to the function above.
//    func setupListener(businessAddress: String, completion: @escaping (Any) -> Void) {
//        
//        Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(businessAddress).collection(GlobalVariables.UserIDs.subscriberCollection).document((Auth.auth().currentUser?.email)!).addSnapshotListener { (document, error) in
//            
//            guard error == nil else {return}
//            let returnValue = ((document?.get(GlobalVariables.UserIDs.recieveAlerts)) != nil) as Bool
//            if returnValue == true {
//                completion(returnValue)
//            } else {
//                return
//            }
//            
//            
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//}
//





//MARK:- Extension 
extension CustomerHomeScreen {
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
                
                
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                print("This is working.111")
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}





