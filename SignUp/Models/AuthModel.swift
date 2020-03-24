//
//  AuthModel.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

struct AuthModel: Codable {
    let name: String
    let email: String
    let password: String
    
    
    init(name: String = "", email: String = "", password: String = "") {
        self.name = name
        self.password = password
        self.email = email
    }
}
