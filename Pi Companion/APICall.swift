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
    
    var asyncCompletionHandler = { () -> Void in
        print("POST ASYNC TASK CALLED")
    }
    
    init(urlString: String, apiKey: String) {
        self.url = URL(string: "\(urlString)?key=\(apiKey)")
    }
    
    var time: String?
    
    func performApiCall() {
        var apiRequest = URLRequest(url: url!)
        let sharedSession = URLSession.shared
        
        apiRequest.httpMethod = "GET"
        
        let apiTask = sharedSession.dataTask(with: apiRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            self.jsonData = data
            self.finished = true
            
            self.asyncCompletionHandler()
        })
        apiTask.resume()
    }
}
