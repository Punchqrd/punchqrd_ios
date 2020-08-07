//
//  BusinessSearch.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/26/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GooglePlaces
import Lottie

//try and set a protocol for notify the customer view controller when to setup a listener for the business added
protocol BusinessSearchProtocol: class {
    func isListening(BusinessName: String, businessAddress: String)
    func printThisTest(value: String)
}



class BusinessSearch: UIViewController {
    
    var delegate : BusinessSearchProtocol?
    
    let animationView = AnimationView()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var businessName : String?
    
    var AddressLabel = UILabel()
    var BusinessNameLabel = UILabel()
    var AddButton = UIButton()
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //this is the code from google api
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back"), style: .plain, target: self, action:#selector(back))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
        setupButtons()
        searchController!.searchBar.barStyle = .default
        searchController!.searchBar.searchTextField.leftView?.tintColor = .black
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.black
    }
    
    
    //MARK:- View Setup
    func setupButtons() {
        BusinessNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(BusinessNameLabel)
        BusinessNameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        BusinessNameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        BusinessNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70).isActive = true
        BusinessNameLabel.textAlignment = .natural
        BusinessNameLabel.font = UIFont(name: "Poppins-Regular", size: 20)
        BusinessNameLabel.numberOfLines = 0
        BusinessNameLabel.textColor = .black
        
        AddressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(AddressLabel)
        AddressLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        AddressLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        AddressLabel.topAnchor.constraint(equalTo: BusinessNameLabel.bottomAnchor, constant: 20).isActive = true
        AddressLabel.textAlignment = .natural
        AddressLabel.numberOfLines = 0
        AddressLabel.font = UIFont(name: "Poppins-Light", size: 17)
        AddressLabel.textColor = .black
        
        
        AddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(AddButton)
        AddButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        AddButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        AddButton.layer.cornerRadius = 60
        AddButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        AddButton.setTitle("+", for: .normal)
        AddButton.titleLabel?.textColor = .white
        AddButton.addTarget(self, action: #selector(AddBusiness), for: .touchUpInside)
        AddButton.backgroundColor = Global_Colors.colors.refresherColor
        AddButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        AddButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
    
    
    //MARK:- Actions
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
  
    
    @objc func AddBusiness() {
        
        self.addLoadingView()
        if let substituteValue = self.businessName {
            GlobalVariables.ActualIDs.ActualAddedBusinessForCustomer = substituteValue
            let db = Firestore.firestore()
            let businessCollection = db.collection(GlobalVariables.UserIDs.existingBusinesses).document(self.AddressLabel.text!)
            businessCollection.getDocument { (doc, err) in
                if let doc = doc, doc.exists {
                    
                    
                    
                    //create a new collection within the users documents
                    let collection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(GlobalVariables.ActualIDs.ActualAddedBusinessForCustomer!)
                    //set certain field values within the collection
                    collection.getDocument { (doc, error) in
                        if let doc = doc, doc.exists {
                            self.removeLoadingView()
                            self.searchController?.searchBar.placeholder = "Business already added"
                        } else {
                            let BusinessAddressCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.BusinessAddressCollection).document(self.AddressLabel.text!)
                            BusinessAddressCollection.setData(["ID" : self.AddressLabel.text!])
                            
                            
                            collection.setData([GlobalVariables.UserIDs.PointsString : 0, GlobalVariables.UserIDs.RedemptionNumberString : 0, GlobalVariables.UserIDs.BonusPointsString : "0", GlobalVariables.UserIDs.CustomerTotalSpent: 0, GlobalVariables.UserIDs.UserAddress: self.AddressLabel.text!])
                            
                            
                            //we also want the user to subscribe to the business they added.
                            let businessCollection = Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(self.AddressLabel.text!).collection(GlobalVariables.UserIDs.subscriberCollection).document((Auth.auth().currentUser?.email)!)
                            businessCollection.setData([GlobalVariables.UserIDs.isSubscribed: true, GlobalVariables.UserIDs.recieveAlerts: false])
                            
                            
                            
                            //also set a listener for that business to receive any sort of future notification
                            ///at this point just pass back a value to the delegate of the class
                            self.removeLoadingView()

                            self.delegate?.isListening(BusinessName: self.businessName!, businessAddress: self.AddressLabel.text!)
                            self.delegate?.printThisTest(value: self.businessName!)///this is just a test function in the delegate to see if its working.
                            
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    
                    
                    
                }   else {
                    self.removeLoadingView()
                    //present alert saying that the business doesnt exist in the databaseyet.
                    
                    let alert = UIAlertController(title: "Well...", message: "Looks like this business doesn't use Punchqrd yet.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true)
                    
                    
                }
                
            }
            
            
        } else {
            self.removeLoadingView()
            searchController?.searchBar.placeholder = "Find a business"}
        
    }
    
    //MARK:- Animations
    func addLoadingView() {
        self.setupAnimation()
    }
    
    func setupAnimation() {
        let animationTitle = ["CroissantLoader", "CoffeeLoader", "BeerLoader"]
        let randomNumber = Int.random(in: 0...2)
        self.animationView.animation = Animation.named(animationTitle[randomNumber])
        self.animationView.frame.size.height = self.view.frame.height
        self.animationView.frame.size.width = self.view.frame.width
        self.animationView.contentMode = .center
        self.animationView.backgroundColor = .white
        
        self.animationView.play()
        self.animationView.loopMode = .loop
        self.view.addSubview(self.animationView)
        
    }
    func removeLoadingView() {
        self.animationView.stop()
        self.animationView.removeFromSuperview()
        
    }
    
}

//MARK:- Extensions
//this extension is from the api
extension BusinessSearch: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        searchController?.searchBar.placeholder = place.name
        
        self.businessName = place.name
        self.BusinessNameLabel.text = place.name
        self.AddressLabel.text = place.formattedAddress
        // Do something with the selected place.
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



