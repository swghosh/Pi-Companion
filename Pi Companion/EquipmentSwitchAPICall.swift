//
//  EquipmentSwitchAPICall.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 20/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation

class EquipmentSwitchAPICall: APICall {
    
    var equipment: EquipmentItem?
    
    convenience init(urlString: String, apiKey: String, channelIdentifier: Character) {
        self.init(urlString: urlString, apiKey: apiKey)
        print("\(urlString)?key=\(apiKey)&channel=\(channelIdentifier)")
        self.url = URL(string: "\(urlString)?key=\(apiKey)&channel=\(channelIdentifier)")
    }
    
    func getEquipment() -> EquipmentItem? {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! [String: Any]
            let dict = json["result"] as! [String: String]
            
            equipment = EquipmentItem(channelIdentifier: dict.keys.first!.first!, channelPowerStatus: dict[dict.keys.first!]!.elementsEqual("high"))
        }
        catch {
            print(error)
        }
        return equipment
    }
}
