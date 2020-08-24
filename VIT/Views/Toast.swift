//
//  Toast.swift
//  VIT
//
//  Created by Aritro Paul on 23/08/20.
//

import UIKit

class Toast: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 25
    }

}
