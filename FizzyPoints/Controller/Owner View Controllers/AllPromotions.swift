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
    let promotionsObjectsArray : [Promotion_Objects] = []
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
        setupBackButton()
        setupTableView()
        
        
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
       
}


extension AllPromotions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
