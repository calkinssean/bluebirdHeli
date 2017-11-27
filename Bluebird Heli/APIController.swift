//
//  APIController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/26/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class APIController {
    
    func get(urlString: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            completion(data)
  
        }
    }
    
}
