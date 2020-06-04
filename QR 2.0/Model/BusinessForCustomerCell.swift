//
//  BusinessForCustomerCell.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BusinessForCustomerCell: UITableViewCell {

    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var Points: UILabel!
    @IBOutlet weak var PointsProgressBar: UIProgressView!
    @IBOutlet weak var CheckMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        PointsProgressBar.transform = PointsProgressBar.transform.scaledBy(x: 1, y: 5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
