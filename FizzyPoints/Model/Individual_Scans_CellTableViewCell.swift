//
//  Individual_Scans_CellTableViewCell.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit

class Individual_Scans_CellTableViewCell: UITableViewCell {

    let dateLabel = UILabel()
    let priceLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabel(dateValue: String, price: Double) {
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height)
        self.addSubview(dateLabel)
        self.dateLabel.text = dateValue
        self.dateLabel.font = UIFont(name: "Poppins", size: 14)
        self.dateLabel.textAlignment = .center
        self.dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.size.height/2).isActive = true
        
        
       
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        self.priceLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height)
        self.priceLabel.text = String(describing: "$\(price)")
        self.priceLabel.font = UIFont(name: "Poppins-Light", size: 14)
        self.priceLabel.textAlignment = .center
        self.priceLabel.leftAnchor.constraint(equalTo: self.dateLabel.rightAnchor, constant: 20).isActive = true
        self.priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.size.height/2).isActive = true

        
    }
    
}
