//
//  OwnerDataObject.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/7/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit

//this class creates an obect for data chunks in from the database that will be shown to the user.
class OwnerDataObject {
    
    var totalScans : Int?
    var totalRevenue: Double?
    var totalRedemptions: Int?
    var averageRevenue: Double?
    
    init(totalScans : Int?, totalRevenue: Double?, totalRedemptions: Int?, averageRevenue: Double?) {
        self.totalScans = totalScans
        self.totalRevenue = totalRevenue
        self.totalRedemptions = totalRedemptions
        self.averageRevenue = averageRevenue
    }
    
}
