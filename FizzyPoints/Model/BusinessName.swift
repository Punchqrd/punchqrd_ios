//
//  BusinessName.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/27/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation

//creating a new business from this class. everytime a user adds a new business, an instance of this object is created.
class BusinessName {
    
    var name : String
    var points : Float
    var code : Int
    var bonusPoints : Int
    var address: String
    
    init(inputName : String?, pointsAdded : Float?, redemptionCode : Int?, bonusPoints : Int?, address: String) {
        self.name = inputName!
        self.code = redemptionCode!
        self.points = pointsAdded!
        self.bonusPoints = bonusPoints!
        self.address = address
        
    }
}
