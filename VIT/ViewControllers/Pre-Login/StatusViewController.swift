//
//  StatusViewController.swift
//  VIT
//
//  Created by Aritro Paul on 25/07/20.
//

import UIKit

class StatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loginStatus = VIT.shared.fetchLoginState()
        if loginStatus == true {
            self.performSegue(withIdentifier: "loggedin", sender: Any?.self)
        }
        else {
            self.performSegue(withIdentifier: "notloggedin", sender: Any?.self)
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }

}
