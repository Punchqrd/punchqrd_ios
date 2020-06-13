//
//  ScanDataFile.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/7/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ScanDataFile : UIViewController {
    
    var businessDataHolder : [OwnerDataObject] = []
    
    @IBOutlet weak var TotalScansNumberLabel: UILabel!
    
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateData()
    }
    
    //MARK:- Suplimentary functions
    func populateData() {
        let db = Firestore.firestore()
        let TotalScansDoc = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        
        TotalScansDoc.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                
                //this is where you can add data to a new object from the database
                let newData = OwnerDataObject(totalScans: doc.get(GlobalVariables.UserIDs.CustomerPurchasesString) as? Int)
                
                self.businessDataHolder.append(newData)
                self.TotalScansNumberLabel.text = String(describing: self.businessDataHolder[0].totalScans!)
            } else {
                return
            }
        }
        
        
        

        
    }
    
    
    
    
}
