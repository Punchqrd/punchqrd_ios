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
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    
    //MARK:- Function Calls
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
