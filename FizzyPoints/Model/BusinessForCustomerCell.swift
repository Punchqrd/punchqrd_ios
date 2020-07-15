//
//  BusinessForCustomerCell.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Lottie

class BusinessForCustomerCell: UITableViewCell {
    
    //Variable/Constant/Object Declaration
    let animationView = AnimationView()
    
    //Outlet Declaration
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var Points: UILabel!
    @IBOutlet weak var PointsProgressBar: UIProgressView!
    @IBOutlet weak var CheckMarkImage: UIImageView!
    @IBOutlet weak var BonusPointsLabel: UILabel!
    @IBOutlet weak var ActualPointsLabel: UILabel!
    @IBOutlet weak var PerkString: UILabel!
    @IBOutlet weak var MainView: UIView!
    
    //MARK:- Function Calls
    override func awakeFromNib() {
        super.awakeFromNib()
       //
        PointsProgressBar.transform = PointsProgressBar.transform.scaledBy(x: 1, y: 6)
        layoutView()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func animateCheckMark() {
        self.setupAnimation()
    }
    
    
    func setupAnimation() {
        self.animationView.animation = Animation.named("CheckMark3")
        self.animationView.frame.size.height = self.CheckMarkImage.frame.height
        self.animationView.frame.size.width = self.CheckMarkImage.frame.width
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.loopMode = .loop
        self.animationView.backgroundColor = .white
        self.animationView.play()
        self.CheckMarkImage.addSubview(self.animationView)
        self.MainView.sendSubviewToBack(self.CheckMarkImage)    }
    
    func layoutView() {
         
         // set the shadow of the view's layer
         layer.backgroundColor = UIColor.clear.cgColor
         layer.shadowColor = UIColor.black.cgColor
         layer.shadowOffset = CGSize(width: 0, height: 1.0)
         layer.shadowOpacity = 0.2
         layer.shadowRadius = 4.0
           
         // set the cornerRadius of the containerView's layer
         MainView.layer.cornerRadius = 20
         MainView.layer.masksToBounds = true
         
         
         //
         // add additional views to the containerView here
         //
         
         // add constraints
         MainView.translatesAutoresizingMaskIntoConstraints = false
         
         // pin the containerView to the edges to the view
         MainView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
         MainView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
         MainView.topAnchor.constraint(equalTo: topAnchor).isActive = true
         MainView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
       }
    
    
}
