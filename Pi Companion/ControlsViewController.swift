//
//  ViewController.swift
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
    
    var channelNames: [Character: String] = [
        Character("A") : "Tubelight",
        Character("B") : "Table Lamp",
        Character("C") : "Fan",
        Character("D") : "Night Lamp"
    ]

    func prepareTableData() {
        
        let apiCall = StatusAPICall(urlString: "http://192.168.43.195:2017/api/readstatus", apiKey: "Z9FpluAnv")
        apiCall.asyncCompletionHandler = { () -> Void in
            self.equipments = apiCall.getEquipmentsStatus()
            
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
        
        activity.startAnimating()
        prepareTableData()
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
        
        cell.channelName.text = "\(channelNames[cell.linkedEquipment!.identifier]!)"
        cell.channelDescription.text = "Remote control switching of the  channel \(equipments[indexPath.row].identifier) - \(channelNames[cell.linkedEquipment!.identifier]!). Switching proceeds by use of wireless network."
        cell.channelSwitch.isOn = cell.linkedEquipment!.status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 85.0
        return UITableViewAutomaticDimension
    }
}

