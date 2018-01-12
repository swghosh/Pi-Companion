//
//  ControlsViewController.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 05/08/17.
//  Copyright © 2017 SwG Ghosh. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var equipments: [EquipmentItem] = [EquipmentItem]()
    
    var applianceNames: [Character: String] = [
        Character("A") : "Tubelight",
        Character("B") : "Table Lamp",
        Character("C") : "Fan",
        Character("D") : "Night Lamp"
    ]

    func prepare() {
        
        self.activity.startAnimating()
        
        let apiCall = EquipmentsStatusAPICall(urlString: "http://192.168.43.195:2017/api/readstatus", apiKey: "Z9FpluAnv")
        apiCall.onCompleteAsyncTask = { () -> Void in
            self.equipments = apiCall.getEquipments()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activity.stopAnimating()
            }
        }
        
        apiCall.performApiCall()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipments.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Equipments / Appliances"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchTableViewCell
        
        cell.linkedEquipment = equipments[indexPath.row]
        
        cell.channelName.text = "\(applianceNames[cell.linkedEquipment!.channelIdentifier]!)"
        cell.channelDescription.text = "Remotely switch the power state of the appliance connected to channel \(cell.linkedEquipment!.channelPowerStatus). A \(applianceNames[cell.linkedEquipment!.channelIdentifier]!) is currently connected to this channel."
        cell.channelSwitch.isOn = cell.linkedEquipment!.channelPowerStatus
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 85.0
        return UITableViewAutomaticDimension
    }
}

