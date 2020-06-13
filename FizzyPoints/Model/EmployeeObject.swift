//
//  EmployeeObject.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation

class EmployeeObject {
    
    var name : String?
    var password : String?
    var email : String?
    
    init(name :  String?, password : String?, email : String?) {
        self.name = name
        self.password = password
        self.email = email
    }
    
}
