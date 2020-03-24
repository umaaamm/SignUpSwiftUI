//
//  AuthHttpRouter.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Alamofire

enum AuthHttpRouter {
    case signUp(AuthModel)
    case ValidateEmail(email: String)
}

extension AuthHttpRouter: HttpRouter {
    
    var baseUrlString : String {
        return "https://letscodeeasy.com/groceryapi/public/api"
//        return "http://localhost/ci-restserver/index.php"
    }
    
    var path: String {
        switch (self) {
        case .signUp:
            return "register"
        case .ValidateEmail:
            return "validate/email"
        }
    }
    
    var method: HTTPMethod {
        switch (self) {
        case .signUp, .ValidateEmail:
            return .post
        }
    }
    
    var headers: HTTPHeaders?{
        switch (self) {
        case .signUp, .ValidateEmail:
            return [
                "Content-Type":"application/json; charset=UTF-8"
//                "Content-Type":"application/x-www-form-urlencoded"
            ]
        }
    }
    
    var parameters: Parameters?{
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .signUp(let user):
            return try JSONEncoder().encode(user)
        case .ValidateEmail(let email):
            return try JSONEncoder().encode(["email" : email])
        }
    }
    
    
}
