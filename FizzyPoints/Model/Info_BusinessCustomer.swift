//
//  Info_BusinessCustomer.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/19/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit

class Info_BusinessCustomer: UIView {
    
    var parentView = UIView()
    
    //info we want to import from the superview
    var totalSpent: Double?
    var totalScans: Int?
    var nameOfBusiness: String?
    var totalSpentLabel = UILabel()
    var totalScansLabel = UILabel()
    var nameOfBusinessLabel = UILabel()
    var containerView = UIView()
    
    
    
    init(parentView: UIView, totalSpent: Double?, totalScans: Int?, nameOfBusiness: String) {
        self.parentView = parentView
        self.totalScans = totalScans
        self.totalSpent = totalSpent
        self.nameOfBusiness = nameOfBusiness
        super.init(frame: parentView.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
      
        self.containerView.frame = CGRect(x: 0, y: 0, width: parentView.frame.size.width, height: parentView.frame.size.height)
        self.containerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.containerView.center.x = parentView.frame.size.width/2
        self.containerView.center.y = parentView.frame.size.height/2
        
        self.frame = CGRect(x: 0, y: 0, width: parentView.frame.size.width/1.5, height: parentView.frame.size.height/2)
        self.center.x = self.parentView.frame.size.width/2
        self.center.y = -self.parentView.frame.size.height/2
        self.backgroundColor = .systemPurple
        B_1Register.setupShadow(view: self)
        self.layer.cornerRadius = 30
        
        self.totalSpentLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/3)
        self.totalSpentLabel.center.x = self.frame.size.width/2
        self.totalSpentLabel.center.y = self.frame.size.height/3
        self.totalSpentLabel.text = "$ Spent: $\(String(describing: self.totalSpent!))"
        self.totalSpentLabel.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        self.totalSpentLabel.textColor = .white
        self.totalSpentLabel.textAlignment = .center
        self.addSubview(totalSpentLabel)
        
        self.totalScansLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/3)
        self.totalScansLabel.center.x = self.frame.size.width/2
        self.totalScansLabel.center.y = self.frame.size.height/2
        self.totalScansLabel.text = "Total Scans: \(String(describing: self.totalScans!))"
        self.totalScansLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 20)
        self.totalScansLabel.textColor = .white
        self.totalScansLabel.textAlignment = .center
        self.addSubview(totalScansLabel)
        
        self.nameOfBusinessLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/3)
        self.nameOfBusinessLabel.center.x = self.frame.size.width/2
        self.nameOfBusinessLabel.center.y = self.frame.size.height/6
        self.nameOfBusinessLabel.text = "\(String(describing: self.nameOfBusiness!))"
        self.nameOfBusinessLabel.font = UIFont(name: Fonts.importFonts.mainTitleFont, size: 20)
        self.nameOfBusinessLabel.textColor = .white
        self.nameOfBusinessLabel.textAlignment = .center
        self.nameOfBusinessLabel.numberOfLines = 0
        self.addSubview(nameOfBusinessLabel)
               
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.removeView))
        self.addGestureRecognizer(gesture)
        
        self.parentView.addSubview(containerView)
        self.parentView.addSubview(self)
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                     
            self.center.y = self.parentView.frame.size.height/2
        }, completion: nil)
    }
    
    @objc func removeView() {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                            
                self.center.y = -self.parentView.frame.size.height/2
                self.containerView.removeFromSuperview()
                
                    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.removeFromSuperview()


            }
                   
               }, completion: nil)
    }
}
