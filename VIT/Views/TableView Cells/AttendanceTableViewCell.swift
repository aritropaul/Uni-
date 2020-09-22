//
//  AttendanceTableViewCell.swift
//  VIT
//
//  Created by Aritro Paul on 22/08/20.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func markAttendance(attendance: GetAttendanceDetail) {
        dateLabel.text = attendance.attendanceDate
        dayLabel.text = attendance.attendanceDay.map { $0.rawValue }
        statusLabel.text = attendance.attendanceStatus?.rawValue.capitalized
        switch attendance.attendanceStatus {
        case .present: statusLabel.textColor = .systemGreen
        case .onDuty: statusLabel.textColor = .systemYellow
        case .absent: statusLabel.textColor = .systemRed
        case .none:
            statusLabel.textColor = .label
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
