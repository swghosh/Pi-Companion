//
//  PreferencesViewController.swift
//  Pi Companion
//
//  Created by SwG Ghosh on 29/01/18.
//  Copyright © 2018 SwG Ghosh. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    let apiKey = "Z9FpluAnv"
    
    @IBOutlet weak var controlServerAddressTextField: UITextField!
    @IBOutlet weak var controlServerPortTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let serverPreferences = ServerPreferences.loadServerPreferences()
        if(serverPreferences !== nil) {
            controlServerAddressTextField.text = "\(serverPreferences!.piServerAddress)"
            controlServerPortTextField.text = "\(serverPreferences!.piServerPort)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressSave(_ sender: Any) {
        print("File save path is \(ServerPreferences.JSONFileURL.path).")
        
        let serverPreferences = ServerPreferences(piServerAddress: controlServerAddressTextField.text!, piServerPort: Int(controlServerPortTextField.text!)!)
        ServerPreferences.saveServerPreferences(serverPreferences: serverPreferences)
    }
    
    @IBAction func pressStopServer(_ sender: Any) {
        
        let apiCall = StopServerAPICall(urlString: ServerPreferences.getApiURLStrings()["exit"]!, apiKey: apiKey)
        apiCall.performApiCall()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
