//
//  OnboardingView.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/22/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit

class OnboardingView: UIView {
    
    var mainView = UIView()
    var parentView = UIView()
    var titleLabel = UILabel()
    var instructionLabel = UITextView()
    let defaults = UserDefaults.standard

    
    init(parentView: UIView) {
        self.parentView = parentView
        super.init(frame: parentView.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    //function to setup the main screen
    func setupMainView() {
        self.frame = CGRect(x: 0, y: 0, width: parentView.frame.size.width/1.2, height: parentView.frame.size.height/1.1)
        self.center.x = parentView.frame.size.width/2
        self.center.y = -parentView.frame.size.height/2
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        parentView.addSubview(self)
        parentView.bringSubviewToFront(self)
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.removeView))
        self.addGestureRecognizer(gesture)
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.center.y = self.parentView.frame.size.height/2
        }, completion: nil)

    }
    
    //setup the first view that the use sees
    func setupFirstView() {
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        titleLabel.center.x = self.frame.size.width/2
        titleLabel.center.y = self.frame.size.height/5
        titleLabel.text = "Ready For Simple Perks?"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 15)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        instructionLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.5, height: self.frame.size.height/2)
        instructionLabel.textAlignment = .center
        instructionLabel.center.x = self.frame.size.width/2
        instructionLabel.center.y = self.frame.size.height/1.5
        instructionLabel.textContainer.maximumNumberOfLines = 15
        instructionLabel.textContainer.lineBreakMode = .byTruncatingTail
        instructionLabel.font = UIFont(name: "Poppins-Light", size: 14)
        instructionLabel.text = "Go show your local businesses some love! Every time you purchase something, they'll scan your app, and you'll earn redemption points. Cash in and get a free perk the business provides. Then do it all again. That simple. That easy. No hassle."
        instructionLabel.isUserInteractionEnabled = false
        self.addSubview(instructionLabel)
    }
    
    //objc functions
    @objc func removeView() {
        //handling user defaults logic when the onboarding
        GlobalVariables.ActualIDs.isFirstTime = false
        defaults.set(GlobalVariables.ActualIDs.isFirstTime, forKey: GlobalVariables.UserIDs.isUserFirstTime)
        print(GlobalVariables.ActualIDs.isFirstTime)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.center.y = -self.parentView.frame.size.height/2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.removeFromSuperview()
            }
        }, completion: nil)
       
    }
    
    
    
    
    
}
