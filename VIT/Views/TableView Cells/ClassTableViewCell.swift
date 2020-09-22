//
//  ClassTableViewCell.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
