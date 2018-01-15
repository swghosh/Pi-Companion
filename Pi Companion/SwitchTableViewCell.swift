//
//  SwitchTableViewCell.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 06/08/17.
//  Copyright © 2017 SwG Ghosh. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelDescription: UILabel!
    @IBOutlet weak var channelSwitch: UISwitch!
    
    weak var linkedEquipment: EquipmentItem?
}
