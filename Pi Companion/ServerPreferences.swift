//
//  ServerPreferences.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 24/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation

class ServerPreferences: Codable {
    
    var piServerAddress: String
    var piServerPort: Int

    init(piServerAddress: String, piServerPort: Int) {
        self.piServerAddress = piServerAddress
        self.piServerPort = piServerPort
    }
    
    static let JSONFileURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("serverpreferences.json")
    
    static func saveServerPreferences(serverPreferences: ServerPreferences) {
        // encode data
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(serverPreferences)
            // write to file
            try String(data: jsonData, encoding: .utf8)?.write(to: JSONFileURL, atomically: true, encoding: .utf8)
        }
        catch {
            return
        }
    }
    
    static func loadServerPreferences() -> ServerPreferences? {
        do {
            // read from file
            let jsonString = try String(contentsOf: JSONFileURL)
            let jsonData = jsonString.data(using: .utf8)
            // decode data
            let jsonDecoder = JSONDecoder()
            return try
                jsonDecoder.decode(ServerPreferences.self, from: jsonData!)
        }
        catch {
            return nil
        }
        
    }
    
    static let piServerDefaultAddress = "raspberrypi.local"
    static let piServerDefaultPort = 2017
    
    static func getApiURLStrings() -> [String: String] {
        let serverPreferences = ServerPreferences.loadServerPreferences()
        return [
            "readstatus": "http://\(serverPreferences?.piServerAddress ?? piServerDefaultAddress):\(serverPreferences?.piServerPort ?? piServerDefaultPort)/api/readstatus",
            "setlow": "http://\(serverPreferences?.piServerAddress ?? piServerDefaultAddress):\(serverPreferences?.piServerPort ?? piServerDefaultPort)/api/setlow",
            "sethigh": "http://\(serverPreferences?.piServerAddress ?? piServerDefaultAddress):\(serverPreferences?.piServerPort ?? piServerDefaultPort)/api/sethigh",
            "exit": "http://\(serverPreferences?.piServerAddress ?? piServerDefaultAddress):\(serverPreferences?.piServerPort ?? piServerDefaultPort)/api/exit"
        ]
    }
    
}
