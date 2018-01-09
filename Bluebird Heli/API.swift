//
//  API.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/9/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import Foundation

class API {
    
    func request(urlString: String, path: String, method: RequestMethod, params: [String: String]? = nil) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                var index = 0
                if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                    if index < params.count - 1 {
                        paramString += "\(escapedKey)=\(escapedValue)&"
                    } else {
                        paramString += "\(escapedKey)=\(escapedValue)"
                    }
                    index += 1
                }
            }
            request.httpBody = paramString.data(using: .utf8)
        }
        
        return request
    }
    
    func dataTask(request: URLRequest, completion: (Bool, Data, HTTPURLResponse)) {
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error?.localizedDescription)
            }
            
        }
    }
}

enum RequestMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Patch = "PATCH"
    case Delete = "DELETE"
}
