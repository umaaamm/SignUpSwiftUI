//
//  TokenResponseModel.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

struct TokenResponseModel : Decodable {
    
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    
    enum CodingKeys: String, CodingKey {
        
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
