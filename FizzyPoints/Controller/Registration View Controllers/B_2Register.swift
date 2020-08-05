//
//  B_2Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import GooglePlaces
import GoogleMaps
import Lottie


//this is the OWNER view controller register class
class B_2Register : UIViewController {
    
    let animationView = AnimationView()
    let db = Firestore.firestore()
    
    var confirmedAddress : Bool?
    var confirmedName : Bool?
    var businessName : String?
    var businessAddress : String?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var nameConfirmButton: UIButton!
    @IBOutlet weak var addressConfirmButton: UIButton!
    @IBOutlet weak var NameLabel : UILabel!
    @IBOutlet weak var checkMarksLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        setupToHideKeyboardOnTapOnView()
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Remove the background color.
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        
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
        searchController?.searchBar.placeholder = "Lookup your business."
        searchController?.searchBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        GlobalFunctions.setButtonRadius(button: self.ConfirmButton)
        //instnatinate these as false when the user opens the screen
        self.confirmedName = false
        self.confirmedAddress = false
        self.ConfirmButton.isHidden = true
        self.nameConfirmButton.isHidden = true
        self.addressConfirmButton.isHidden = true
        self.checkMarksLabel.isHidden = true
        self.searchController?.searchBar.text = nil
        
    }
    
    //MARK:- Actions
    
    @IBAction func BusinessConfirm(_ sender: UIButton) {
        if confirmedAddress == true && confirmedName == true {
            
            
            let db = Firestore.firestore()
            let businessCollection = db.collection(GlobalVariables.UserIDs.existingBusinesses).document(self.businessAddress!)
                   businessCollection.getDocument { (doc, err) in
                       if let doc = doc, doc.exists {
                            
                           let alert = UIAlertController(title: "Hmmm", message: "Looks like this business already belongs to somebody else!", preferredStyle: .alert)
                           
                           alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
                               alert.dismiss(animated: true, completion: nil)
                           }))
                        
                                self.present(alert, animated: true)

                        
                       } else {
                        
                        
                        GlobalVariables.ActualIDs.ActualBusinessName = self.businessName
                        GlobalVariables.ActualIDs.ActualZipCode = self.businessAddress
                        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.PostBusinessSearchSegue, sender: self)
                        
                    }
                       
                   }
            
            
            
        } else {self.errorLabel.text = "Please check the marks to confirm."}
    }
    
    
    @IBAction func ConfirmNameAction(_ sender: UIButton) {
        self.nameConfirmButton.tintColor = .green
        self.confirmedAddress = true
        if self.confirmedName == true {
            self.checkMarksLabel.textColor = .lightGray
            self.ConfirmButton.isHidden = false
        }
    }
    
    
    @IBAction func ConfirmAddress(_ sender: UIButton) {
        self.addressConfirmButton.tintColor = .green
        self.confirmedName = true
        if self.confirmedAddress == true {
            self.checkMarksLabel.textColor = .lightGray
            self.ConfirmButton.isHidden = false
        }
    }
    
    //create the notification
    @IBAction func CancelButton(_ sender: UIButton) {
        self.cancelAlert(title: "Cancel Process?", message: "This will take you back home")
    }
    
    
    //MARK:- Alerts
    func cancelAlert(title : String?, message : String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
        
    }
    
    
    //MARK:- Animations
    func addLoadingView() {
        self.setupAnimation()
    }
    
    
    func setupAnimation() {
        
        
        self.animationView.animation = Animation.named(GlobalVariables.animationTitles.mainLoader)
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
extension B_2Register: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchController?.searchBar.text = place.name
        self.businessAddress = place.formattedAddress
        self.businessName = place.name
        self.AddressLabel.text = place.formattedAddress
        self.NameLabel.text = place.name
        self.addressConfirmButton.tintColor = .gray
        self.nameConfirmButton.tintColor = .gray
        self.ConfirmButton.isHidden = true
        self.confirmedName = false
        self.confirmedAddress = false
        self.addressConfirmButton.isHidden = false
        self.nameConfirmButton.isHidden = false
        self.checkMarksLabel.isHidden = false
        self.checkMarksLabel.textColor = .black
        
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











