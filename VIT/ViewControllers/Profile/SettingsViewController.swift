//
//  SettingsViewController.swift
//  VIT
//
//  Created by Aritro Paul on 16/09/20.
//

import UIKit
import SPAlert

class SettingsViewController: UITableViewController {

    @IBOutlet weak var regNumLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        regNumLabel.text = regNum
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = version
       }
        
    }

    
    @IBAction func logoutTapped(_ sender: Any) {
        VIT.loggedIn = false
        regNum = ""
        VIT.shared.saveLoginState()
        SPAlert.present(title: "Logged out", preset: .done)
        self.parent?.parent?.performSegue(withIdentifier: "unwindToLogin", sender: Any?.self)
    }
    
}
