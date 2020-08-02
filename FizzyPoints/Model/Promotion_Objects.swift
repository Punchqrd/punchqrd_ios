//
//  Promotion_Objects.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/30/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit

class Promotion_Objects: Equatable {
    
    
      var message: String
      var imageID: UIImage?
      var date: String
      var businessName: String
      
    
    static func == (lhs: Promotion_Objects, rhs: Promotion_Objects) -> Bool {
            return lhs.businessName == rhs.businessName && lhs.businessName == rhs.businessName

    }
    
    
    
    
  

    
    init(message: String, imageID: UIImage?, date: String, businessName: String) {
        self.message = message
        self.imageID = imageID
        self.businessName = businessName
        self.date = date
    }
}
