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
            [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
             NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 25)!]
        
        navigationItem.title = "All Promotions"
        setupTableView()
        setupBackButton()

        
        
    }
    
    
    func setupBackButton() {
        let backGroundImage = UIImage(systemName: "chevron.down")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        backButton.setBackgroundImage(tintedImage, for: .normal)
        backButton.tintColor = Global_Colors.colors.coolMint
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
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
                            let message = promotions.get(GlobalVariables.UserIDs.Message) as! String
                            let photoID = promotions.get(GlobalVariables.UserIDs.BinaryID)
                            
                            
                            //now go into the firebase to get the photo to ultimaetly append it to the array as part of a new promotions object.
                            // Create a reference to the file you want to download
                            let downloadRef = Storage.storage().reference(withPath: "\(businessAddress)/\(String(describing: photoID!)).jpg")
                            //                            let downloadMetaData = StorageMetadata.init()
                            //                            downloadMetaData.contentType = "image/jpg"
                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                            downloadRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print(error)
                                    return
                                }
                                
                                
                                if let data = data {
                                    
                                    //this is where we can populate all of the values in the array...
                                    let newImage = UIImage(data: data)
                                    let newPromotion = Promotion_Objects(message: message, imageID: newImage!, date: date, businessName: nameofBusiness)
                                    self.promotionsObjectsArray.append(newPromotion)
                                    DispatchQueue.main.async { self.tableView.reloadData() }
                                    self.tableView.reloadData()
                                    
                                }
                                
                                
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                }
            }
            
        }
    }
    
}





extension AllPromotions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionsObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.Promo_NibCellFileName, for: indexPath) as! Promo_Cell
        cell.businessDate.text = promotionsObjectsArray[indexPath.row].date
        cell.businessImage.image = promotionsObjectsArray[indexPath.row].imageID
        cell.businessMessage.text = promotionsObjectsArray[indexPath.row].message
        cell.businessMessage.numberOfLines = 0
        cell.businessTitle.text = promotionsObjectsArray[indexPath.row].businessName
        cell.parentView = self.view
        print(cell.parentView.frame.size.width/2)
        print(cell.parentView.frame.size.height/2)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
       

        return cell
    }
    

    
    
    
    
}
