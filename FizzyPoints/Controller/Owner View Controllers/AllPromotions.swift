//
//  AllPromotions.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/30/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import Lottie
import FirebaseStorage
import FirebaseAuth

class AllPromotions: UIViewController {
    
    
    //variable declarations
    let backButton = UIButton()
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    var promotionsObjectsArray : [Promotion_Objects] = []
    //view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "All Promotions"
        self.navigationController?.navigationBar.barTintColor = .white
        setupTableView()
        setupBackButton()
        refreshTableView()
        
        
        
    }
    
    
    func setupBackButton() {
        
        let containerForButton = UIView()
        
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerForButton)
        containerForButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        containerForButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        containerForButton.backgroundColor = .white
        containerForButton.layer.cornerRadius = 35
        
        let backGroundImage = UIImage(systemName: "chevron.down")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setBackgroundImage(tintedImage, for: .normal)
        backButton.tintColor = Global_Colors.colors.coolMint
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        containerForButton.addSubview(backButton)
        
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.centerXAnchor.constraint(equalTo: containerForButton.centerXAnchor, constant: 0).isActive = true
        backButton.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor, constant: 0).isActive = true
        backButton.bottomAnchor.constraint(equalTo: containerForButton.centerYAnchor, constant: 0).isActive = true
        
        
        containerForButton.bringSubviewToFront(backButton)
        containerForButton.layer.shadowColor = UIColor.lightGray.cgColor
        containerForButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerForButton.layer.shadowRadius = 10
        containerForButton.layer.shadowOpacity = 0.3
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.frame = self.view.frame
        tableView.center = self.view.center
        self.view.addSubview(tableView)
        showList()
    }
    
    //handler functions
    @objc func popBack() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    func showList() {
        createPromotions()
        tableView.dataSource = self
        tableView.register(Promo_Cell.self, forCellReuseIdentifier: GlobalVariables.UserIDs.Promo_NibCellFileName)
        
        
        
    }
    //MARK:- Table View Logic
    
    func findNewDate(businessAddress: String, completion: @escaping (Any) -> Void) {
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.existingBusinesses).document(businessAddress).getDocument { (document, error) in
            if let document = document, document.exists {
                let returnValue = document.get(GlobalVariables.UserIDs.newDate)
                completion(returnValue as Any)
            } else {return}
        }
        
    }
    
    
    
    
    
    func createPromotions() {
        
        self.promotionsObjectsArray = []
        //access the database
        let db = Firestore.firestore()
        //(1) specify the path to the current users business
        let ownerInfo = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!)
        ownerInfo.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                //fetched the string
                let businessAddress = doc.get(GlobalVariables.UserIDs.UserZipCode) as! String //user address (1)
                let nameofBusiness = doc.get(GlobalVariables.UserIDs.BusinessName) as! String
                
                
                
                
                //now go back into the primary collection to fetch all of the documents from the promotion tab
                let allPromotions = db.collection(GlobalVariables.UserIDs.existingBusinesses).document(businessAddress).collection(GlobalVariables.UserIDs.MessageCollectionTitle)
                allPromotions.getDocuments { (documents, err) in
                    if let err = err {
                        print(err)
                        return
                        
                    } else {
                        for promotions in documents!.documents {
                            
                            //extract the details from the documents
                            let date = promotions.documentID
                            let photoID = promotions.get(GlobalVariables.UserIDs.BinaryID)
                            let message = promotions.get(GlobalVariables.UserIDs.Message)
                            self.findNewDate(businessAddress: businessAddress) { (newDate) in
                                let thisDate = newDate as! String
                                //now go into the firebase to get the photo to ultimaetly append it to the array as part of a new promotions object.
                                // Create a reference to the file you want to download
                                let downloadRef = Storage.storage().reference(withPath: "\(businessAddress)/\(String(describing: photoID!)).jpg")
                                
                                let taskReference = downloadRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                                    
                                    if let image = data {
                                        let newImage = UIImage(data: image)
                                        let newPromotion = Promotion_Objects(message: message as! String, imageID: newImage, date: date, businessName: nameofBusiness, newDate: thisDate)
                                        self.promotionsObjectsArray.append(newPromotion)
                                        DispatchQueue.main.async { self.tableView.reloadData() }
                                        self.tableView.reloadData()
                                        self.refresher.endRefreshing()
                                    } else {
                                        let newPromotion = Promotion_Objects(message: message as! String, imageID: nil, date: date, businessName: nameofBusiness, newDate: thisDate)
                                        self.promotionsObjectsArray.append(newPromotion)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                            self.refresher.endRefreshing()
                                        }
                                    }
                                    
                                    
                                }
                                
                                taskReference.observe(.progress) { (snapshot) in
                                    guard let pctThere = snapshot.progress?.fractionCompleted else { return }
                                    print(pctThere)
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
            }
        }
        
    }
    
    
    func refreshTableView() {
        //this is the refresh list variables to enable a refresh for the UITableView
        
        
        refresher.tintColor = .lightGray
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refresher)
        
        
    }
    
    @objc func refresh() {
        //calls the function below
        
        refreshData()
        
    }
    
    
    
    //function to refresh the data on the page
    func refreshData() {
        
        
        
        refresher.backgroundColor = UIColor.white
        
        DispatchQueue.main.async {
            self.createPromotions()
            self.tableView.reloadData()
            self.tableView.dataSource = self
        }
        
        
    }
    
    
}





//MARK:-table view logic


extension AllPromotions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionsObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.Promo_NibCellFileName, for: indexPath) as! Promo_Cell
        
//        if let image = promotionsObjectsArray[indexPath.row].imageID {
            
            cell.businessDate.text = promotionsObjectsArray[indexPath.row].date
            cell.businessDate.numberOfLines = 0
            cell.businessImage.image = promotionsObjectsArray[indexPath.row].imageID
            cell.businessMessage.text = promotionsObjectsArray[indexPath.row].message
            cell.businessMessage.numberOfLines = 0
            cell.businessTitle.text = promotionsObjectsArray[indexPath.row].businessName
            cell.parentView = self.view
        
        
//        } else {
//            cell.businessImage.removeFromSuperview()
//            cell.parentView = self.view
//            cell.businessDate.text = promotionsObjectsArray[indexPath.row].date
//            cell.businessDate.numberOfLines = 0
//            cell.businessMessage.topAnchor.constraint(equalTo: cell.businessDate.bottomAnchor, constant: 5).isActive = true
//            cell.businessMessage.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -30).isActive = true
//            cell.businessMessage.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 30).isActive = true
//            cell.businessMessage.text = promotionsObjectsArray[indexPath.row].message
//            cell.businessMessage.numberOfLines = 0
//            cell.businessTitle.text = promotionsObjectsArray[indexPath.row].businessName
//        }
//
        
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none

        
        
        return cell
    }
    
    
    
    //MARK:- did tap cell
    //resend the promotion?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Repost this promotion?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            
            
            Firestore.firestore().collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).getDocument { (businessName, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else{
                    
                    let name = businessName?.get(GlobalVariables.UserIDs.UserZipCode) as! String
                    
                    let db = Firestore.firestore()
                    let file = db.collection(GlobalVariables.UserIDs.existingBusinesses).document(name)
                    file.getDocument { (document, error) in
                        if let document = document, document.exists {
                            //want a date
                            
                            //find the current values and set it to a value
                            //                            let currentDate = document.get(GlobalVariables.UserIDs.dateUploaded) as! String
                            let currentMessage = document.get(GlobalVariables.UserIDs.Message) as! String
                            
                            if self.promotionsObjectsArray[indexPath.row].message == currentMessage {
                                let action = UIAlertController(title: "This already is your current post!", message: nil, preferredStyle: .alert)
                                action.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                                    return
                                }))
                                self.present(action, animated: true, completion: nil)
                                return
                            }
                                
                            else {
                                //now do logic to find if all of the values in the promotions collection exist based on the currently selected date.
                                let promotions = db.collection(GlobalVariables.UserIDs.existingBusinesses).document(name).collection(GlobalVariables.UserIDs.MessageCollectionTitle)
                                promotions.getDocuments { (promos, error) in
                                    
                                    //
                                    for values in promos!.documents {
                                        
                                        //looping through the documents in the collection to see if the one we selected matches an older date.
                                        if self.promotionsObjectsArray[indexPath.row].date == values.documentID {
                                            print(self.promotionsObjectsArray[indexPath.row].date)
                                            //when we find the matched value...
                                            
                                            //retreive the old message and image.
                                            let updatedMessages = values.get(GlobalVariables.UserIDs.Message) as! String
                                            let updatedImage = values.get(GlobalVariables.UserIDs.BinaryID) as! String
                                            
                                            //set a new time
                                            let currentDateTime = Date()
                                            let formatter = DateFormatter()
                                            formatter.timeStyle = .medium
                                            formatter.dateStyle = .long
                                            formatter.string(from: currentDateTime)
                                            let date = formatter.string(from: currentDateTime)
                                            
                                            //now set the new message in the current promotion section with the values we found.
                                            file.updateData([GlobalVariables.UserIDs.Message: updatedMessages, GlobalVariables.UserIDs.BinaryID: updatedImage,GlobalVariables.UserIDs.newDate : date, GlobalVariables.UserIDs.dateUploaded: values.documentID])
                                            
                                            DispatchQueue.main.async {
                                                let action = UIAlertController(title: "Posted!", message: nil, preferredStyle: .alert)
                                                action.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
                                                    return
                                                }))
                                                
                                                self.present(action, animated: true, completion: nil)
                                            }
                                            
                                            break
                                            
                                            
                                        } else {
                                            continue
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            return
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
}
