//
//  EquipmentItem.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 09/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

class EquipmentItem {
    var status: Bool
    var identifier: Character
    
    init(identifier: Character, status: Bool) {
        self.identifier = identifier
        self.status = status
    }
}
