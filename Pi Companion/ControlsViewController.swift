//
//  ControlsViewController.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 05/08/17.
//  Copyright © 2017 SwG Ghosh. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let apiKey = "Z9FpluAnv"
    
    // MARK : Storyboard Outlets
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serverLabel: UILabel!
    
    // MARK : Model Items
    var equipments: [EquipmentItem] = [EquipmentItem]()
    
    var applianceNames: [Character: String] = [
        Character("A") : "Tubelight",
        Character("B") : "Table Lamp",
        Character("C") : "Fan",
        Character("D") : "Night Lamp"
    ]

    // MARK : Local Methods
    
    func prepare() {
        
        self.activity.startAnimating()
        
        let apiCall = EquipmentsStatusAPICall(urlString: ServerPreferences.getApiURLStrings()["status"]!, apiKey: apiKey)
        apiCall.onCompleteAsyncTask = { [unowned self] () -> Void in
            self.equipments = apiCall.getEquipments()
            
            DispatchQueue.main.async(execute: { [unowned self] () -> Void in
                self.tableView.reloadData()
                self.activity.stopAnimating()
            })
        }
        apiCall.onErrorAsyncTask = { [unowned self] () -> Void in
            
            DispatchQueue.main.async(execute: { [unowned self] () -> Void in
                self.activity.stopAnimating()
                self.networkIssue()
            })
        }
        
        apiCall.performApiCall()
    }
    
    func networkIssue() {
        let netAlertController = UIAlertController(title: "Network Issue", message: "Pi Companion is not being able to communicate with the Pi Server. Please ensure that the Pi is switched on, is running the relay server program and is connected to the same network as with this device.", preferredStyle: .alert)
        netAlertController.addAction(UIAlertAction(title: "Okay, I'll just check!", style: .default, handler: nil))
        self.present(netAlertController, animated: true, completion: nil)
    }
    
    func switchIssue() {
        let netAlertController = UIAlertController(title: "Issue", message: "Pi Companion could not switch the power state due to miscommunication with Pi Server. You can give it another try.", preferredStyle: .alert)
        netAlertController.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
        self.present(netAlertController, animated: true, completion: nil)
    }
    
    // MARK : View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let serverPreferences = ServerPreferences.loadServerPreferences()
        if(serverPreferences != nil) {
            serverLabel.text = "\(serverPreferences!.piServerAddress):\(serverPreferences!.piServerPort)"
        }
        
        prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Table View Data Source Methods
    
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
        cell.channelDescription.text = "Remotely switch the power state of the appliance connected to channel \(cell.linkedEquipment!.channelPowerStatus). \(applianceNames[cell.linkedEquipment!.channelIdentifier]!) is currently connected to this channel."
        cell.channelSwitch.isOn = cell.linkedEquipment!.channelPowerStatus
        
        cell.channelSwitch.channelIdentifier = cell.linkedEquipment!.channelIdentifier
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 85.0
        return UITableViewAutomaticDimension
    }
    
    @IBAction func controlSwitchChanged(_ sender: Any) {
        let channelSwitch = sender as! PowerStateControlSwitch
        let channelIdentifier = channelSwitch.channelIdentifier!
        let channelPowerStatus = channelSwitch.isOn
        
        var apiCall: EquipmentSwitchAPICall
        
        let completed = { [unowned self] () -> Void in
            
            DispatchQueue.main.async(execute: { [unowned self] () -> Void in
                self.prepare()
            })
        }
        
        let issued = { [unowned self] () -> Void in
            
            DispatchQueue.main.async(execute: { [unowned self] () -> Void in
                self.switchIssue()
            })
        }
        
        if(channelPowerStatus) {
            apiCall = EquipmentSwitchAPICall(urlString: ServerPreferences.getApiURLStrings()["setlow"]!, apiKey: apiKey, channelIdentifier: channelIdentifier)
            apiCall.onCompleteAsyncTask = completed
            apiCall.onErrorAsyncTask = issued
            apiCall.performApiCall()
        }
        else {
            apiCall = EquipmentSwitchAPICall(urlString: ServerPreferences.getApiURLStrings()["sethigh"]!, apiKey: apiKey, channelIdentifier: channelIdentifier)
            apiCall.onCompleteAsyncTask = completed
            apiCall.onErrorAsyncTask = issued
            apiCall.performApiCall()
        }
    }
}

