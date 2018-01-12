//
//  EquipmentsStatusAPICall.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 09/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation

class EquipmentsStatusAPICall: APICall {
    
    var equipments: [EquipmentItem]
    
    override init(urlString: String, apiKey: String) {
        self.equipments = [EquipmentItem]()
        super.init(urlString: urlString, apiKey: apiKey)
    }
    
    func getEquipments() -> [EquipmentItem] {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! [String: Any]
            let list = json["result"] as! [String: String]
            
            for (key, value) in list {
                equipments.append(EquipmentItem(channelIdentifier: key.first!, channelPowerStatus: value.elementsEqual("high")))
            }
            
        }
        catch {
            print(error)
        }
        return equipments
    }
}
