//
//  Customer_Feed.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 8/1/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class Customer_Feed: UIViewController {
    
    //variables
    private lazy var backDropView: UIView = {
        let animationView = UIView()
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        animationView.backgroundColor = .white
        return animationView
    }()
    
    private lazy var animation: AnimationView = {
        let animation = AnimationView()
        return animation
    }()
    
    

    var businessNamesOUT = [String]()
    var businessDetails = [String: [String: Any]]()
    var secondtoFinalArray = [Promotion_Objects]()
    var returnArray = [Promotion_Objects]()
    var tableView = UITableView()
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.tableView.dataSource = self
        self.tableView.register(Promo_Cell.self, forCellReuseIdentifier: GlobalVariables.UserIDs.Promo_NibCellFileName)
        
        let animationTitle = ["CroissantLoader", "CoffeeLoader", "BeerLoader"]
        let randomNumber = Int.random(in: 0...2)
        self.setupAnimation(parentView: self.view, animationView: animation, animationName: animationTitle[randomNumber])
                    
     
        startSearch()
       
        
        
        let backToMainGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapBackButton))
        backToMainGesture.direction = .left
        self.view.addGestureRecognizer(backToMainGesture)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .systemPurple
        navigationItem.title = String(describing: "What's new?")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        
    }
    
    
    func startSearch() {
        findExistingBusinessSubscibed { (true, response) in
                   guard let names = response as? [String] else {return}
                   self.businessNamesOUT = names
                   //now call the next function to grab the data from the database.
                   self.retrieveMessageDataFromBusiness { (true, response) in
                       
                       guard let names = response as? [String: [String: Any]] else {
                           self.backDropView.removeFromSuperview()
                           self.presentReturnAction(withMessage: "Add some business to view their feed.")
                           return
                           
                       }
                    
                       self.businessDetails = names
                    
                    
                       self.retrieveImage(inputArray: self.businessDetails) { (true, response) in
                           
                           
                           guard let dataForCell = response as? [Promotion_Objects] else {

                               self.backDropView.removeFromSuperview()
                               return
                           }
                           
                        self.secondtoFinalArray.append(contentsOf: dataForCell)
                        self.returnArray = self.secondtoFinalArray.uniqueElements()
                        
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
         

                        
                     
                            
                           self.backDropView.removeFromSuperview()
                        
                        
                           
                       }

                   }
            

               }
    }
    
   
    func presentReturnAction(withMessage: String) {
        let alert = UIAlertController(title: withMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
             
            let navigationController = self.navigationController
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.popViewController(animated: false)
        }))
        self.present(alert, animated: true, completion: {
           print("ok")
        })
    }
   
    func setupView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        
        
        //side button setup
        let containerForButton = UIView()
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerForButton)
        self.view.bringSubviewToFront(containerForButton)
        containerForButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerForButton.layer.cornerRadius = 35
        containerForButton.backgroundColor = Global_Colors.colors.sideFeedButton
        containerForButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        containerForButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 35).isActive = true
        containerForButton.layer.shadowColor = UIColor.lightGray.cgColor
        containerForButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerForButton.layer.shadowRadius = 10
        containerForButton.layer.shadowOpacity = 0.4
               
               
               
               
        let backGroundImage = UIImage(systemName: "chevron.left")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        containerForButton.addSubview(backButton)
        containerForButton.bringSubviewToFront(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .clear
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.leftAnchor.constraint(equalTo: containerForButton.leftAnchor, constant: 15).isActive = true
        backButton.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor, constant: 0).isActive = true
              
        
        
        
    }
    
    @objc func didTapBackButton() {
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    
    
    //MARK:- Table View Logic
    func findExistingBusinessSubscibed(completion: @escaping (Bool, Any?) -> Void) {
        
        
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.BusinessAddressCollection).getDocuments { (businesses, error) in
            if let error = error {
                print("there has been an error fetching the documents: \(error.localizedDescription)")
            } else {
                var businessNamesINArray = [String]()
                for business in businesses!.documents {
                    businessNamesINArray.append(business.get("ID") as! String)
                }
                if businessNamesINArray.isEmpty {
                    self.presentReturnAction(withMessage: "Add some business to view their feed.")
                    return
                } else {
                    completion(true, businessNamesINArray)
                }
                
            }
        }
         
    }
    
    func retrieveMessageDataFromBusiness(completion: @escaping (Bool, Any?) -> Void) {
        //find the business from the existing business collection
        let db = Firestore.firestore()
        db.collection(GlobalVariables.UserIDs.existingBusinesses).getDocuments { (business, error) in
            if let error = error {
                print(error)
                return
            }
            
            else {
                var businessDetails = [String: [String: Any]]()
                for business in business!.documents {
                    
                    for values in self.businessNamesOUT {
                        if values == business.documentID {
                            db.collection(GlobalVariables.UserIDs.existingBusinesses).document(values).getDocument { (documents, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                } else {
//                                    for documents in documents!.documents {
                                    guard documents!.get(GlobalVariables.UserIDs.Message) != nil else {
                                        return
                                        
                                    }
                                    guard documents!.get(GlobalVariables.UserIDs.BinaryID) != nil else {return}
                                    guard documents!.get(GlobalVariables.UserIDs.dateUploaded) != nil else {return}
                                    print(documents!.get(GlobalVariables.UserIDs.dateUploaded)!)
                                    
                                    businessDetails[values] = [GlobalVariables.UserIDs.Message: documents!.get(GlobalVariables.UserIDs.Message)!, GlobalVariables.UserIDs.BinaryID: documents!.get(GlobalVariables.UserIDs.BinaryID)!, GlobalVariables.UserIDs.date: documents!.get(GlobalVariables.UserIDs.dateUploaded)!]
                                        completion(true, businessDetails)
                                        
//                                    }
                                    
                                    
                                }

                            }
                        }
                        
                    }
                }
            }
            
            
        }
        
        
    }
    
    func retrieveImage(inputArray: [String: [String: Any]], completion: @escaping (Bool, Any?) -> Void) {
        var returnArray = [Promotion_Objects]()
        for values in self.businessNamesOUT {
            guard inputArray[values] != nil else {
                continue
            }

            let downloadRef = Storage.storage().reference(withPath: "\(values)/\(String(describing: inputArray[values]![GlobalVariables.UserIDs.BinaryID]!)).jpg")
        downloadRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            
            if let image = data {
                
                
                
                let newImage = UIImage(data: image)
                
                Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(values).getDocument { (doc, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    } else {
                        
                        let nameOfBusiness = doc?.get(GlobalVariables.UserIDs.BusinessName) as! String
                        let newDate = doc?.get(GlobalVariables.UserIDs.newDate) as! String
                        let newObject = Promotion_Objects(message: inputArray[values]![GlobalVariables.UserIDs.Message] as! String, imageID: newImage, date: inputArray[values]![GlobalVariables.UserIDs.date] as! String, businessName: nameOfBusiness, newDate: newDate)
                        returnArray.append(newObject)
                        
                        

                        completion(true, returnArray)
                        

                    }
                }
               
                
            }
            
        }
        }

    }
    
    
}

extension Customer_Feed: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.returnArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.Promo_NibCellFileName, for: indexPath) as! Promo_Cell

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
//        DispatchQueue.main.async {
        cell.parentView = self.view
        cell.businessDate.text = self.returnArray[indexPath.row].newDate
        cell.businessMessage.numberOfLines = 0
        cell.businessImage.image = self.returnArray[indexPath.row].imageID
        cell.businessMessage.text = self.returnArray[indexPath.row].message
        cell.businessTitle.text = self.returnArray[indexPath.row].businessName
            
//        }
        
        cell.selectionStyle = .none
//        cell.textLabel.backgroundColor = uicol
        return cell
        
    }
    
    
    
    //MARK:- animation func
    func setupAnimation(parentView: UIView, animationView: AnimationView, animationName: String) {
        
        
        
        
        animationView.animation = Animation.named(animationName)
        animationView.frame = CGRect(x: 0, y: 0, width: parentView.frame.size.width/2, height: parentView.frame.size.width/2)
        animationView.center.x = parentView.frame.width/2
        animationView.center.y = parentView.frame.height/2
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        animationView.play()
        animationView.loopMode = .loop
        
        let backGroundView = backDropView
        backGroundView.addSubview(animationView)
        parentView.addSubview(backGroundView)
    }
    
    
}


extension Array where Element: Equatable {
  func uniqueElements() -> [Element] {
    var out = [Element]()
    
    for element in self {
      if !out.contains(element) {
        out.append(element)
      }
    }

    return out
  }
}

