//
//  GradeTableViewCell.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit

class GradeTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
