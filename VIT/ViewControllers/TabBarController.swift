//
//  TabBarController.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import UIKit
import SPAlert

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SPAlert.present(title: "Welcome", message: "Successfully Logged in", preset: .done)
    }

}
