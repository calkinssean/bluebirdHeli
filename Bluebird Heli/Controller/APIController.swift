//
//  APIController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/26/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class APIController {
    
    func get(urlString: String, completion: @escaping ([String: Any]) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error in APIController")
                print(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    completion(json)
                }
            } catch {
                print("Error in API Controller")
                print(error.localizedDescription)
            }
  
        }.resume()
    }
    
}
