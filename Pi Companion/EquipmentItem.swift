//
//  EquipmentItem.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 09/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

class EquipmentItem {
    var channelPowerStatus: Bool
    var channelIdentifier: Character
    
    init(channelIdentifier: Character, channelPowerStatus: Bool) {
        self.channelIdentifier = channelIdentifier
        self.channelPowerStatus = channelPowerStatus
    }
}
