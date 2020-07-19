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
    let BusinessName = UILabel()
    let CheckMarkImage = UIImageView()
    let BonusPointsLabel = UILabel()
    let ActualPointsLabel = UILabel()
    @IBOutlet weak var PerkString: UILabel!
    let pointsCircle = UIView()
    let PointsProgressBar = UIProgressView()
    let progressBarBackground = UIView()
    
    //MARK:- Function Calls
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressBarBack()
        setupLabels()
        setupPointsView()
    }
    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupLabels() {
        BusinessName.frame.size.width = progressBarBackground.frame.size.width
        BusinessName.frame.size.height = progressBarBackground.frame.size.height
        BusinessName.center.x = self.frame.size.width/3.3
        BusinessName.center.y = self.frame.height/5
        BusinessName.textColor = .black
        BusinessName.font = UIFont(name: "Poppins-Light", size: 15)
        BusinessName.textAlignment = .center
        self.addSubview(BusinessName)
    }
    
    func setupPointsView() {
        pointsCircle.frame = CGRect(x: 0, y: 0, width: progressBarBackground.frame.size.height, height: progressBarBackground.frame.size.height)
        pointsCircle.layer.cornerRadius = progressBarBackground.frame.size.height/2
        pointsCircle.backgroundColor = .purple
        pointsCircle.center.x = self.frame.size.width / 1.3
        pointsCircle.center.y = progressBarBackground.center.y
        
        ActualPointsLabel.frame = pointsCircle.frame
        ActualPointsLabel.center.x = pointsCircle.frame.size.width/2
        ActualPointsLabel.center.y = pointsCircle.frame.size.height/2
        ActualPointsLabel.font = UIFont(name: "Poppins-Bold", size: 20)
        ActualPointsLabel.textColor = .white
        ActualPointsLabel.textAlignment = .center
        pointsCircle.addSubview(ActualPointsLabel)
        pointsCircle.sendSubviewToBack(ActualPointsLabel)
        
        CheckMarkImage.frame = pointsCircle.frame
        CheckMarkImage.center.x = pointsCircle.frame.size.width/2
        CheckMarkImage.center.y = pointsCircle.frame.size.height/2
        pointsCircle.addSubview(CheckMarkImage)
        
        
        //bonus points
        BonusPointsLabel.frame = pointsCircle.frame
        BonusPointsLabel.center.x = pointsCircle.frame.size.width/2
        BonusPointsLabel.center.y = pointsCircle.frame.size.height/2
        BonusPointsLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        BonusPointsLabel.textAlignment = .center
        
        pointsCircle.addSubview(BonusPointsLabel)
        
        self.addSubview(pointsCircle)
    }
    
    func setupProgressBarBack() {
        progressBarBackground.frame.size.width = self.frame.size.width/2
        progressBarBackground.frame.size.height = self.frame.size.height/3.5
        
        progressBarBackground.backgroundColor = .purple
        progressBarBackground.layer.cornerRadius = progressBarBackground.frame.size.width/12.5
        progressBarBackground.center.x = self.frame.size.width/3.3
        progressBarBackground.center.y = self.frame.size.height/2

            
        PointsProgressBar.frame.size.width = progressBarBackground.frame.size.width - 50
        PointsProgressBar.frame.size.height = progressBarBackground.frame.size.height - 50
        PointsProgressBar.center.x = progressBarBackground.frame.size.width/2
        PointsProgressBar.center.y = progressBarBackground.frame.size.height/2
        PointsProgressBar.transform = PointsProgressBar.transform.scaledBy(x: 1, y: 6)
        progressBarBackground.addSubview(PointsProgressBar)
        B_1Register.setupShadow(view:PointsProgressBar)
        
        
        
        self.addSubview(progressBarBackground)
        
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
    
    
    }
}
