//
//  Promo_Cell.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/30/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit

class Promo_Cell: UITableViewCell, UITextFieldDelegate {
    
    let businessTitle = UILabel()
    var businessMessage = UILabel()
    let businessImage = UIImageView()
    let businessView = UIView()
    let businessDate = UILabel()
    let viewImageButton = UIButton()
    var parentView = UIView()
    
    let backView = UIButton()
    let newLargeImage = UIImageView()
    
    
    
    
    
    var isTappedImage = true
    private lazy var isTappedLargeImage: UIButton = {
        let isTappedLargeImage = UIButton()
        return isTappedLargeImage
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(businessTitle)
        businessTitle.translatesAutoresizingMaskIntoConstraints = false
        businessTitle.font = UIFont(name: "Poppins-Regular", size: 15)
        businessTitle.textAlignment = .left
        businessTitle.textColor = .black
        businessTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        businessTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        businessTitle.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(businessDate)
        businessDate.translatesAutoresizingMaskIntoConstraints = false
        businessDate.font = UIFont(name: "Poppins-Light", size: 13)
        businessDate.textAlignment = .left
        businessDate.textColor = .lightGray
        businessDate.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
//        businessDate.heightAnchor.constraint(equalToConstant: 10).isActive = true
        businessDate.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessDate.topAnchor.constraint(equalTo: self.businessTitle.bottomAnchor, constant: 0).isActive = true
        
        
        addSubview(businessView)
        businessView.translatesAutoresizingMaskIntoConstraints = false
        businessView.layer.cornerRadius = (self.frame.size.width/3)/2
        businessView.backgroundColor = .clear
        businessView.heightAnchor.constraint(equalToConstant: self.frame.size.width/3).isActive = true
        businessView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        businessView.topAnchor.constraint(equalTo: businessDate.bottomAnchor, constant: 5).isActive = true
        
        businessView.addSubview(businessImage)
        businessImage.translatesAutoresizingMaskIntoConstraints = false
        businessImage.layer.cornerRadius = (self.frame.size.width/3)/2
        businessImage.clipsToBounds = true
        businessImage.heightAnchor.constraint(equalToConstant: self.frame.size.width/3).isActive = true
        businessImage.widthAnchor.constraint(equalToConstant: self.frame.size.width/3).isActive = true
        
        businessImage.leftAnchor.constraint(equalTo: businessView.leftAnchor, constant: 0).isActive = true
        //            businessImage.rightAnchor.constraint(equalTo: businessView.rightAnchor, constant: 0).isActive = true
        businessImage.centerXAnchor.constraint(equalTo: businessView.centerXAnchor).isActive = true
        businessImage.centerYAnchor.constraint(equalTo: businessView.centerYAnchor).isActive = true
        businessView.sendSubviewToBack(businessImage)
        
        
        businessView.addSubview(viewImageButton)
        businessView.bringSubviewToFront(viewImageButton)
        viewImageButton.translatesAutoresizingMaskIntoConstraints = false
        viewImageButton.layer.cornerRadius = (self.frame.size.width/3)/2
        viewImageButton.isEnabled = true
        viewImageButton.backgroundColor = .clear
        viewImageButton.addTarget(self, action: #selector(didTapImage), for: .touchUpInside)
        viewImageButton.heightAnchor.constraint(equalToConstant: self.frame.size.width/3).isActive = true
        viewImageButton.widthAnchor.constraint(equalToConstant: self.frame.size.width/3).isActive = true
        //            viewImageButton.heightAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        viewImageButton.leftAnchor.constraint(equalTo: businessView.leftAnchor, constant: 0).isActive = true
        //            viewImageButton.rightAnchor.constraint(equalTo: businessView.rightAnchor, constant: 0).isActive = true
        viewImageButton.centerXAnchor.constraint(equalTo: businessView.centerXAnchor, constant: 0).isActive = true
        viewImageButton.centerYAnchor.constraint(equalTo: businessView.centerYAnchor, constant: 0).isActive = true
        
        
        addSubview(businessMessage)
        businessMessage.font = UIFont(name: "Poppins-Normal", size: 14)
        businessMessage.textAlignment = .left
        businessMessage.backgroundColor = .white
        businessMessage.textColor = .black
        businessMessage.translatesAutoresizingMaskIntoConstraints = false
        
        businessMessage.topAnchor.constraint(equalTo: businessDate.bottomAnchor, constant: 0).isActive = true
        businessMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        businessMessage.rightAnchor.constraint(equalTo: businessView.leftAnchor, constant: -5).isActive = true
        businessView.leftAnchor.constraint(equalTo: businessMessage.rightAnchor, constant: 10).isActive = true
        businessView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: businessMessage.bottomAnchor, multiplier: 0).isActive = true
        businessDate.bottomAnchor.constraint(lessThanOrEqualTo: businessMessage.topAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapImage() {
        
        guard let _ = self.businessImage.image else {
            print("Nothing here")
            return
        }
        
        
        
        
        
        if self.isTappedImage == true {
            
            newLargeImage.frame = self.businessView.frame
            newLargeImage.layer.cornerRadius = self.businessView.layer.cornerRadius
            newLargeImage.image = self.businessImage.image
            newLargeImage.center = self.parentView.center
            newLargeImage.clipsToBounds = true
            
            self.parentView.addSubview(newLargeImage)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                
                print("This is being called")
                self.newLargeImage.frame = CGRect(x: 0, y: 0, width: self.parentView.frame.size.width - 10, height: self.parentView.frame.size.width - 10)
                self.newLargeImage.layer.cornerRadius = (self.parentView.frame.size.width - 10)/2
                self.newLargeImage.clipsToBounds = true
                self.newLargeImage.center = self.parentView.center
                
                self.backView.frame = self.parentView.frame
                self.backView.backgroundColor = .clear
                self.backView.addTarget(self, action: #selector(self.didTapImage), for: .touchUpInside)
                self.parentView.addSubview(self.backView)
                self.parentView.bringSubviewToFront(self.backView)
                
                
                
                self.isTappedImage = false
                
                print(self.isTappedImage)
                
                
                
                return
                
                
            }, completion: nil)
        } else {
            print("Minimizing..")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                
                self.newLargeImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.newLargeImage.layer.cornerRadius = self.businessView.layer.cornerRadius
                self.newLargeImage.clipsToBounds = true
                self.newLargeImage.center = self.center
                
                
                self.isTappedImage = true
                
                
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.newLargeImage.removeFromSuperview()
                self.backView.removeFromSuperview()
            }
            
            
            
        }
        
        
    }
    
    
    
}
