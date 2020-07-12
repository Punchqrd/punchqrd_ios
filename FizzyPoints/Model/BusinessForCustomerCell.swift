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
    
    //MARK:- Function Calls
    override func awakeFromNib() {
        super.awakeFromNib()
       //
        PointsProgressBar.transform = PointsProgressBar.transform.scaledBy(x: 1, y: 6)
        
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
    }
    
    
}
