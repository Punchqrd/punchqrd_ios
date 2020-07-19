//
//  CustomerCell.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/17/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit

class CustomerCell: UITableViewCell {

    let emailLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabel(nameofCustomer: String) {
        self.emailLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.emailLabel.text = nameofCustomer
        self.emailLabel.font = UIFont(name: "Poppins", size: 14)
        self.emailLabel.textAlignment = .center
        self.addSubview(emailLabel)
        
    }
    
}
