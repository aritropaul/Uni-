//
//  AttendanceTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 22/08/20.
//

import UIKit

class AttendanceTableViewController: UITableViewController {

    var attendanceDetails = [GetAttendanceDetail]()
    var subject = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = subject.abbr()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atCell", for: indexPath) as! AttendanceTableViewCell
        let attendance = attendanceDetails[indexPath.row]
        cell.markAttendance(attendance: attendance)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
