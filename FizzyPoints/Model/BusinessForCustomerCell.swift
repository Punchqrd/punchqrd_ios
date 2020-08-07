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

class BusinessForCustomerCell: UITableViewCell, UITextFieldDelegate {
    
    //Variable/Constant/Object Declaration
    let animationView = AnimationView()
    
    //Outlet Declaration
    let BusinessName = UILabel()
    let CheckMarkImage = UIImageView()
    let BonusPointsLabel = UILabel()
    let ActualPointsLabel = UILabel()
    let pointsCircle = UIView()
    let PointsProgressBar = UIProgressView()
    let progressBarBackground = UIView()
    let bonusPointsCircle = UIView()
    var parentView = UIView()
    
    //MARK:- Function Calls
    
    
   
    //
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //business title setup
        BusinessName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(BusinessName)
        BusinessName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        BusinessName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        BusinessName.textColor = .black
        BusinessName.font = UIFont(name: "HelveticaNeue", size: 18)
        BusinessName.textAlignment = .justified
        
        
        //progressbar setup
        progressBarBackground.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressBarBackground)
        progressBarBackground.topAnchor.constraint(equalTo: BusinessName.bottomAnchor, constant: 15).isActive = true
        progressBarBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        progressBarBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        progressBarBackground.layer.cornerRadius = 13
        
        
        
        
        progressBarBackground.backgroundColor = .white
        progressBarBackground.layer.shadowColor = UIColor.lightGray.cgColor
        progressBarBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        progressBarBackground.layer.shadowRadius = 10
        progressBarBackground.layer.shadowOpacity = 0.3
        
        
        PointsProgressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBarBackground.addSubview(PointsProgressBar)
        progressBarBackground.bringSubviewToFront(PointsProgressBar)
        PointsProgressBar.centerXAnchor.constraint(equalTo: progressBarBackground.centerXAnchor).isActive = true
        PointsProgressBar.centerYAnchor.constraint(equalTo: progressBarBackground.centerYAnchor).isActive = true
        PointsProgressBar.heightAnchor.constraint(equalToConstant: 15).isActive = true
        PointsProgressBar.rightAnchor.constraint(equalTo: progressBarBackground.rightAnchor, constant: -20).isActive = true
        PointsProgressBar.leftAnchor.constraint(equalTo: progressBarBackground.leftAnchor, constant: 20).isActive = true
        
        
        
        
        
        
        bonusPointsCircle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bonusPointsCircle)
        bonusPointsCircle.backgroundColor = .black
        
        bonusPointsCircle.leftAnchor.constraint(equalTo: progressBarBackground.rightAnchor, constant: 20).isActive = true
        bonusPointsCircle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        bonusPointsCircle.topAnchor.constraint(equalTo: BusinessName.bottomAnchor, constant: 20).isActive = true
        bonusPointsCircle.widthAnchor.constraint(equalToConstant: 25).isActive = true
        bonusPointsCircle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bonusPointsCircle.layer.cornerRadius = 12.5

        BonusPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        bonusPointsCircle.addSubview(BonusPointsLabel)
        bonusPointsCircle.bringSubviewToFront(BonusPointsLabel)
        BonusPointsLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 13)
        BonusPointsLabel.backgroundColor = .clear
        BonusPointsLabel.textColor = .white
        BonusPointsLabel.centerXAnchor.constraint(equalTo: bonusPointsCircle.centerXAnchor).isActive = true
        BonusPointsLabel.centerYAnchor.constraint(equalTo: bonusPointsCircle.centerYAnchor).isActive = true
     
        
        
        pointsCircle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pointsCircle)
        pointsCircle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        pointsCircle.heightAnchor.constraint(equalToConstant: 70).isActive = true
        pointsCircle.widthAnchor.constraint(equalToConstant: 70).isActive = true
        pointsCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pointsCircle.backgroundColor = .black
        pointsCircle.layer.cornerRadius = 35
        pointsCircle.clipsToBounds = true
        self.bringSubviewToFront(pointsCircle)
        
        ActualPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsCircle.addSubview(ActualPointsLabel)
        ActualPointsLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 15)
        ActualPointsLabel.centerYAnchor.constraint(equalTo: pointsCircle.centerYAnchor).isActive = true
        ActualPointsLabel.centerXAnchor.constraint(equalTo: pointsCircle.centerXAnchor).isActive = true
        
        
        bonusPointsCircle.rightAnchor.constraint(equalTo: pointsCircle.leftAnchor, constant: -20).isActive = true
        progressBarBackground.rightAnchor.constraint(equalTo: bonusPointsCircle.leftAnchor, constant: -40).isActive = true
        BusinessName.rightAnchor.constraint(equalTo: pointsCircle.leftAnchor, constant: -20).isActive = true
        
        
       

        
        

//
//

        CheckMarkImage.translatesAutoresizingMaskIntoConstraints = false
        pointsCircle.addSubview(CheckMarkImage)
        pointsCircle.sendSubviewToBack(CheckMarkImage)
        CheckMarkImage.centerYAnchor.constraint(equalTo: pointsCircle.centerYAnchor).isActive = true
        CheckMarkImage.centerXAnchor.constraint(equalTo: pointsCircle.centerXAnchor).isActive = true
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func animateCheckMark() {
        self.setupAnimation()
    }
    
    
    func setupAnimation() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.CheckMarkImage.addSubview(self.animationView)
        animationView.centerXAnchor.constraint(equalTo: self.CheckMarkImage.centerXAnchor, constant: 0).isActive = true
        animationView.centerYAnchor.constraint(equalTo: self.CheckMarkImage.centerYAnchor, constant: 0).isActive = true
        self.animationView.animation = Animation.named("CheckMark3")
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.loopMode = .loop
        self.animationView.backgroundColor = .white
        self.ActualPointsLabel.isHidden = true
        self.pointsCircle.backgroundColor = .white
        self.animationView.play()
        
        
        
    }
}
