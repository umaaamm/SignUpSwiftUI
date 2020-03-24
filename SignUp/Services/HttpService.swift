//
//  HttpService.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Alamofire

protocol HttpService {
    var sessionManger: Session {get set}
    func request(_ urlRequest: URLRequestConvertible)-> DataRequest
}

