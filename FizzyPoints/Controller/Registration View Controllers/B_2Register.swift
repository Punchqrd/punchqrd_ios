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
    
   
    var businessName : String?
    var businessAddress : String?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var NameLabel = UILabel()
    var AddressLabel = UILabel()
    var ConfirmButton = ActionButton(backgroundColor: .systemGreen, title: "Confirm.", image: nil)
    var cancelButton = ActionButton(backgroundColor: .black, title: "Cancel", image: nil)
    
    
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
        searchController?.searchBar.searchTextField.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 15)
        searchController?.searchBar.backgroundColor = .white
        
        //setup the view
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        //instnatinate these as false when the user opens the screen
        self.ConfirmButton.isHidden = true
        self.searchController?.searchBar.text = nil
        
        
    }
    
    func setupView() {
        //bottom up
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        view.addSubview(ConfirmButton)
        ConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        ConfirmButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        ConfirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        ConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        ConfirmButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        ConfirmButton.addTarget(self, action: #selector(BusinessConfirm), for: .touchUpInside)

        view.addSubview(AddressLabel)
        AddressLabel.translatesAutoresizingMaskIntoConstraints = false
        AddressLabel.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        AddressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        AddressLabel.bottomAnchor.constraint(equalTo: ConfirmButton.topAnchor, constant: -30).isActive = true
        AddressLabel.numberOfLines = 0
        AddressLabel.textColor = .lightGray
        AddressLabel.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 18)
            
        view.addSubview(NameLabel)
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        NameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        NameLabel.bottomAnchor.constraint(equalTo: AddressLabel.topAnchor, constant: -10).isActive = true
        NameLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 20)
        NameLabel.textColor = .black
        NameLabel.numberOfLines = 0
        
    
        
        

        
    }
    
    //MARK:- Actions
    
    @objc func BusinessConfirm() {
       
            
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
    }
    
    
    
    
   
    //create the notification
    @objc func cancelAction() {
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
extension B_2Register: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchController?.searchBar.text = place.name
        self.businessAddress = place.formattedAddress
        self.businessName = place.name
        self.AddressLabel.text = place.formattedAddress
        self.NameLabel.text = place.name
      
        self.ConfirmButton.isHidden = false
        
        
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











