//
//  EmployeeCell.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    //Outlet Declarations
     var NameLabel = UILabel()
     var EmailLabel = UILabel()
     var PasswordLabel = UILabel()
    
    
    //MARK:- Function Calls
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        //setup view with labels
        //name label
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/4)
        self.addSubview(NameLabel)
        NameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        NameLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        NameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        NameLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height/4).isActive = true
        NameLabel.textColor = .systemPurple
        NameLabel.font = UIFont(name: "Poppins", size: 20)
        NameLabel.textAlignment = .center
        
        //email label
        EmailLabel.translatesAutoresizingMaskIntoConstraints = false
        EmailLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height/4)
        self.addSubview(EmailLabel)
        EmailLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        EmailLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width/2).isActive = true
        EmailLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height/4).isActive = true
        EmailLabel.topAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 0).isActive = true
        EmailLabel.textColor = .black
        EmailLabel.textAlignment = .left
        EmailLabel.font = UIFont(name: "Poppins-Light", size: 15)
        
        PasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        PasswordLabel.frame = CGRect(x: 0, y: 0, width: EmailLabel.frame.size.width, height: EmailLabel.frame.size.height)
        self.addSubview(PasswordLabel)
        PasswordLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        PasswordLabel.heightAnchor.constraint(equalToConstant: EmailLabel.frame.size.height).isActive = true
        PasswordLabel.widthAnchor.constraint(equalToConstant: EmailLabel.frame.size.width).isActive = true
        PasswordLabel.topAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 25).isActive = true
        PasswordLabel.textAlignment = .left
        PasswordLabel.textColor = .black
        PasswordLabel.font = UIFont(name: "Poppins-Light", size: 15)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
