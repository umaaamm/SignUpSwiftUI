//
//  SignUpErrorModel.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Foundation


struct SignUpErrorModel: Codable {
    let validationErrors: ValidationErrors
    
    enum CodingKeys : String, CodingKey {
        case validationErrors = "validation_errors"
    }
}

struct ValidationErrors: Codable {
    let name, email, password : [String]?
    
}
