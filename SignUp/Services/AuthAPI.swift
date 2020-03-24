//
//  AuthAPI.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Foundation
import Combine


protocol AuthAPI {
    func signUp(username: String,
                email: String,
                password: String) -> Future<(statusCode: Int, data: Data),Error>
    
    func checkEmail(email: String) -> Future<Bool, Never>
    
}
