//
//  StatusAPICall.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 09/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import Foundation

class StatusAPICall: APICall {
    
    var equipments: [EquipmentItem]
    
    override init(urlString: String, apiKey: String) {
        self.equipments = [EquipmentItem]()
        super.init(urlString: urlString, apiKey: apiKey)
    }
    
    func getEquipmentsStatus() -> [EquipmentItem] {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! [String: Any]
            let list = json["result"] as! [String: String]
            
            for (key, value) in list {
                let status: Bool = value.elementsEqual("high")
                equipments.append(EquipmentItem(identifier: key.first!, status: status))
            }
            
        }
        catch {
            print(error)
        }
        return equipments
    }
}
