//
//  AuthServiceParser.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Foundation
import Combine


protocol AuthServiceParseable {
    func parseSignUpResponse(statusCode: Int, data: Data) ->
    AnyPublisher<AuthResult<TokenResponseModel>, Error>
}

class AuthServiceParser: AuthServiceParseable{
    static let shared : AuthServiceParser = AuthServiceParser()
    private init() {}
    
    func parseSignUpResponse(statusCode: Int, data: Data) -> AnyPublisher<AuthResult<TokenResponseModel>, Error> {
        return Just((statusCode: statusCode, data: data))
            .tryMap{ args -> AuthResult<TokenResponseModel> in
                
            guard args.statusCode == 200 else {
                do {
                    let authError = try JSONDecoder().decode(SignUpErrorModel.self, from: args.data)
                    if let nameError = authError.validationErrors.name?.first {
                        return .failure(message: nameError)
                    }
                    if let EmailError = authError.validationErrors.email?.first {
                         return .failure(message: EmailError)
                    }
                    
                    if let PasswordError = authError.validationErrors.password?.first {
                        return .failure(message: PasswordError)
                    }
                } catch {
                    print("SignIn in Failed = \(error)")
                }
                return .failure(message: "Sigin in Failed")
            }
            
                guard let tokenResponseModel = try?
                    JSONDecoder().decode(TokenResponseModel.self, from: args.data) else {
                    throw SignUpError.invalidJSON
                }
                return .success(value: tokenResponseModel)
        }
    .eraseToAnyPublisher()
    }
}
