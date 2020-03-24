//
//  AuthHttpService.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Alamofire

final class AuthHttpService: HttpService {
    var sessionManger: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManger.request(urlRequest).validate(statusCode: 200..<400)
    }
}
