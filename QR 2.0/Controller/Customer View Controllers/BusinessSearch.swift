//
//  BusinessSearch.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/26/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GooglePlaces
import Lottie

class BusinessSearch: UIViewController {
    let animationView = AnimationView()
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var BusinessNameLabel: UILabel!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var businessName : String?
    @IBOutlet weak var AddButton: UIButton!
    
    //this is the button that will add a new business from the selected business to the users list
    @IBAction func AddBusiness(_ sender: UIButton) {
        
        self.addLoadingView()
        if let substituteValue = self.businessName {
            GlobalVariables.ActualIDs.ActualAddedBusinessForCustomer = substituteValue
            let db = Firestore.firestore()
            //create a new collection within the users documents
            let collection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(GlobalVariables.ActualIDs.ActualAddedBusinessForCustomer!)
            //set certain field values within the collection
            collection.getDocument { (doc, error) in
                if let doc = doc, doc.exists {
                    self.removeLoadingView()
                    self.searchController?.searchBar.placeholder = "Business already added"
                } else {
                    
                    collection.setData([GlobalVariables.UserIDs.PointsString : 0, GlobalVariables.UserIDs.RedemptionNumberString : 0, GlobalVariables.UserIDs.BonusPointsString : "0"])
                    self.removeLoadingView()
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            
            
            
            
            
        } else {
            self.removeLoadingView()
            searchController?.searchBar.placeholder = "Find a business"}
        
    }
    
    
    
    
    
        func addLoadingView() {
            
            self.setupAnimation()
        }
        func setupAnimation() {
            let animationNames : [String] = ["CroissantLoader", "BeerLoader", "PizzaLoader", "CoffeeLoader"]
            let randomNumber = Int.random(in: 0...3)
            self.animationView.animation = Animation.named(animationNames[randomNumber])
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
        searchController?.searchBar.placeholder = "Search"
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
    }
    
    func setupButtons() {
        GlobalFunctions.setButtonRadius(button: self.AddButton)
    }
    
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}






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



