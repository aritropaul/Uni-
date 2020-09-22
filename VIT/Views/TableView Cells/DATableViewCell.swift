//
//  DATableViewCell.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit

class DATableViewCell: UITableViewCell {

    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
