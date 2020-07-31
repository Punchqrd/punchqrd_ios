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
    
    
    
    var isTappedImage = false
        
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(businessTitle)
        businessTitle.translatesAutoresizingMaskIntoConstraints = false
        businessTitle.font = UIFont(name: "Poppins-Normal", size: 14)
        businessTitle.textAlignment = .left
        businessTitle.textColor = .black
        businessTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        businessTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        businessTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(businessDate)
        businessDate.translatesAutoresizingMaskIntoConstraints = false
        businessDate.font = UIFont(name: "Poppins-Light", size: 9)
        businessDate.textAlignment = .left
        businessDate.textColor = .lightGray
        businessDate.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        businessDate.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessDate.topAnchor.constraint(equalTo: self.businessTitle.bottomAnchor, constant: 10).isActive = true
               
        
        addSubview(businessView)
        businessView.translatesAutoresizingMaskIntoConstraints = false
        businessView.layer.cornerRadius = 75
        businessView.backgroundColor = .clear
        businessView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        businessView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        businessView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
       
        
        businessView.addSubview(businessImage)
        businessImage.translatesAutoresizingMaskIntoConstraints = false
        businessImage.layer.cornerRadius = 75
        businessImage.clipsToBounds = true
        businessImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        businessImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessImage.centerXAnchor.constraint(equalTo: businessView.centerXAnchor).isActive = true
        businessImage.centerYAnchor.constraint(equalTo: businessView.centerYAnchor).isActive = true
        businessView.sendSubviewToBack(businessImage)
        
        businessView.addSubview(viewImageButton)
        businessView.bringSubviewToFront(viewImageButton)
        viewImageButton.translatesAutoresizingMaskIntoConstraints = false
        viewImageButton.layer.cornerRadius = 75
        viewImageButton.isEnabled = true
        viewImageButton.backgroundColor = .clear
        viewImageButton.addTarget(self, action: #selector(didTapImage), for: .touchUpInside)
        viewImageButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        viewImageButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        viewImageButton.centerXAnchor.constraint(equalTo: businessView.centerXAnchor, constant: 0).isActive = true
        viewImageButton.centerYAnchor.constraint(equalTo: businessView.centerYAnchor, constant: 0).isActive = true


        
        
        
        addSubview(businessMessage)
        businessMessage.font = UIFont(name: "Poppins-Normal", size: 14)
        businessMessage.textAlignment = .natural
        businessMessage.layer.cornerRadius = 10
        businessMessage.backgroundColor = .white
        businessMessage.textColor = .black
        businessMessage.translatesAutoresizingMaskIntoConstraints = false
        businessMessage.widthAnchor.constraint(equalToConstant: self.frame.size.width/1.5).isActive = true
        businessMessage.topAnchor.constraint(equalTo: businessView.bottomAnchor, constant: 20).isActive = true
        businessMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        businessMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        businessMessage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true

        
        
       

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapImage() {
        
        guard let _ = self.businessImage.image else {
            print("Nothing here")
            return
        }
       
        self.isTappedImage = true
        print(parentView.frame)
        if self.isTappedImage == true {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.businessView.frame = CGRect(x: 0, y: 0, width: self.parentView.frame.size.width/2, height: self.parentView.frame.size.width/2)
                self.businessView.center = self.parentView.center
                
                
            }, completion: nil)
        } else {
            print("Minimizing..")
        }
        
        
    }
    
    
    
    
    //
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        setupView()
//
//
//
//
//
//    }
//
//
//
//
//
//    func setupView() {
//        businessTitle.translatesAutoresizingMaskIntoConstraints = false
//        businessTitle.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
//        businessTitle.font = UIFont(name: "Poppins", size: 14)
//        businessTitle.textAlignment = .left
//        self.addSubview(businessTitle)
//        businessTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//        businessTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
//        businessTitle.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
//        businessTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//
//        businessMessage.translatesAutoresizingMaskIntoConstraints = false
//        businessMessage.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/1.5, height: 100)
//        //
//        //
//        businessMessage.textColor = .black
//        businessMessage.font = UIFont(name: "Poppins-Light", size: 14)
//        businessMessage.textAlignment = .natural
//        businessMessage.layer.cornerRadius = 10
//        businessMessage.backgroundColor = .white
//        self.addSubview(businessMessage)
//        businessMessage.widthAnchor.constraint(equalToConstant: self.frame.size.width/1.5).isActive = true
//        businessMessage.topAnchor.constraint(equalTo: businessTitle.bottomAnchor, constant: 5).isActive = true
//        businessMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
//
//
//
//
//        businessView.translatesAutoresizingMaskIntoConstraints = false
//        businessView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - self.frame.size.width/1.5, height: self.frame.size.width - self.frame.size.width/1.5)
//        businessView.layer.cornerRadius = (self.frame.size.height/2)/2
//        businessView.backgroundColor = .clear
//        self.addSubview(businessView)
//        businessView.heightAnchor.constraint(equalToConstant: self.frame.size.height/2).isActive = true
//        businessView.widthAnchor.constraint(equalToConstant: self.frame.size.height/2).isActive = true
//        businessView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
//        businessView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
//        businessMessage.rightAnchor.constraint(equalTo: businessView.leftAnchor, constant: -10).isActive = true
//
//
//        businessImage.translatesAutoresizingMaskIntoConstraints = false
//        businessImage.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - self.frame.size.width/1.5, height: self.frame.size.width - self.frame.size.width/1.5)
//        businessView.addSubview(businessImage)
//        businessImage.layer.cornerRadius = (self.frame.size.height/2)/2
//        businessImage.clipsToBounds = true
//        businessImage.heightAnchor.constraint(equalToConstant: (self.frame.size.height/2)).isActive = true
//        businessImage.widthAnchor.constraint(equalToConstant: (self.frame.size.height/2)).isActive = true
//        businessImage.centerXAnchor.constraint(equalTo: businessView.centerXAnchor).isActive = true
//        businessImage.centerYAnchor.constraint(equalTo: businessView.centerYAnchor).isActive = true
//        businessView.sendSubviewToBack(businessImage)
//
//
//
//
//
//
//        businessDate.translatesAutoresizingMaskIntoConstraints = false
//        businessDate.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//        businessDate.font = UIFont(name: "Poppins", size: 10)
//        businessDate.textAlignment = .center
//        businessDate.textColor = .lightGray
//        self.addSubview(businessDate)
//        businessDate.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        businessDate.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        businessDate.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
//        businessDate.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
}
