//
//  GradeMarksTableViewCell.swift
//  VIT
//
//  Created by Aritro Paul on 26/08/20.
//

import UIKit

class GradeMarksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var marksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMarks(for part: String, marksGiven: Double, maxMarks: Int) {
        titleLabel.text = part
        marksLabel.text = "\(marksGiven) / \(maxMarks)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
