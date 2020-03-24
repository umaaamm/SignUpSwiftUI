//
//  HttpRouter.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Alamofire

protocol HttpRouter: URLRequestConvertible {
    var baseUrlString : String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var headers: HTTPHeaders? {get}
    var parameters: Parameters? {get}
    func body() throws -> Data?
    
    func request(usingHttpService service: HttpService) throws ->
    DataRequest
}

extension HttpRouter {
    var parameter: Parameters? {return nil}
    func body() throws -> Data? {return nil}
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        return request
    }
    
    func request(usingHttpService service: HttpService) throws ->
        DataRequest {
            return try service.request(asURLRequest())
    }
    
}
