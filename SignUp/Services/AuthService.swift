//
//  AuthService.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Foundation
import Combine

enum SignUpError : Error {
    case emailExist
    case invalidData
    case invalidJSON
    case error(error: String)
}

enum AuthResult<T> {
    case success(value: T)
    case failure(message: String)
}

class AuthService {
    lazy var httpService = AuthHttpService()
    static let shared : AuthService = AuthService()
    private init() {}
}

    extension AuthService: AuthAPI {
        func signUp(username: String,
                    email: String,
                    password: String) -> Future<(statusCode: Int, data: Data), Error> {
            
            return Future<(statusCode: Int, data : Data), Error> { [httpService] promise in
                do {
                    try AuthHttpRouter
                        .signUp(AuthModel(name: username, email: email, password: password))
                        .request(usingHttpService: httpService)
                        .responseJSON { (response) in
                            print("data \(response)")
                            guard
                                let statusCode = response.response?.statusCode,
                                let data = response.data,
                               
                                statusCode == 200 else {
                                    promise(.failure(SignUpError.invalidData))
                                    return
                            }
                            promise(.success((statusCode: statusCode, data: data)))
                    }
                } catch {
                    print("Error Nih: \(error)")
                    promise(.failure(SignUpError.invalidData))
                }
            }
        }
    
        func checkEmail(email: String) -> Future<Bool, Never> {
            return Future<Bool, Never>{ [httpService] promise in
                do{
                    try AuthHttpRouter
                        .ValidateEmail(email: email)
                        .request(usingHttpService: httpService)
                        .responseJSON { (response) in
                            guard response.response?.statusCode == 200 else {
                                promise(.success(true))
                                return
                            }
                            promise(.success(true))
                    }
                } catch {
                    promise(.success(false))
                }
                
            }
        }
}
