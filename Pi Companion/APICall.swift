//
//  APICall.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 06/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation
class APICall {
    
    var url: URL?
    var jsonData: Data? = nil
    var finished: Bool = false
    
    var onCompleteAsyncTask: (() -> Void)?
    var onErrorAsyncTask: (() -> Void)?
    
    init(urlString: String, apiKey: String) {
        self.url = URL(string: "\(urlString)?key=\(apiKey)")
    }
    
    func performApiCall() {
        var apiRequest = URLRequest(url: url!)
        let sharedSession = URLSession.shared
        
        apiRequest.httpMethod = "GET"
        
        let apiTask = sharedSession.dataTask(with: apiRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error!)
                
                self.onErrorAsyncTask?()
            }
                
            else {
                self.jsonData = data
                self.finished = true
            
                self.onCompleteAsyncTask?()
            }
        })
        apiTask.resume()
    }
}
