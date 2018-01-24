//
//  ServerPreferences.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 24/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation

class ServerPreferences: NSCoder {
    
    static let SaveFileURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ServerPreferences")
    
    static func save(srvPref: ServerPreferences) -> Bool {
        return NSKeyedArchiver.archiveRootObject(srvPref, toFile: SaveFileURL.path)
    }
    
    static func load() -> ServerPreferences? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SaveFileURL.path) as? ServerPreferences
    }
    
    var piServerAddress: String?
    var piServerPort: Int?
    
    init(piServerAddress: String, piServerPort: Int) {
        self.piServerAddress = piServerAddress
        self.piServerPort = piServerPort
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let port = aDecoder.decodeObject(forKey: "Port") as? Int
            else {
                    return nil
        }
        guard let address = aDecoder.decodeObject(forKey: "Address") as? String
            else {
                return nil
        }
        self.init(piServerAddress: address, piServerPort: port)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.piServerPort!, forKey: "Port")
        aCoder.encode(self.piServerAddress!, forKey: "Address")
    }
}
