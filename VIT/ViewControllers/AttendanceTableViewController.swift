//
//  AttendanceTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 22/08/20.
//

import UIKit

class AttendanceTableViewController: UITableViewController {

    var attendanceDetails = [GetAttendanceDetail]()
    var subject = Day()
    var missedClasses = 0
    var attendedClasses = 0
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    @IBOutlet weak var totalAttendanceLabel: UILabel!
    @IBOutlet weak var missClassStepper: UIStepper!
    @IBOutlet weak var attendClassStepper: UIStepper!
    @IBOutlet weak var missedClassLabel: UILabel!
    @IBOutlet weak var attendedClassLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = subject.course?.abbr()
    }
    

    @IBAction func attendTapped(_ sender: Any) {
        generator.impactOccurred()
        attendedClasses = Int(attendClassStepper.value)
        calculateAttendance(missed: missedClasses, attended: attendedClasses)
    }
    
    @IBAction func missTapped(_ sender: Any) {
        generator.impactOccurred()
        missedClasses = Int(missClassStepper.value)
        calculateAttendance(missed: missedClasses, attended: attendedClasses)
    }
    
    func calculateAttendance(missed: Int, attended: Int) {
        let studentUnits = Int(subject.studentUnits ?? "0")
        let totalUnits = Int(subject.totalUnits ?? "0")
        let totalAttended =  studentUnits! + attended
        let total = totalUnits! + attended + missed
        let attendance : Double = (Double(totalAttended)/Double(total)) * 100
        totalAttendanceLabel.text = String(format: "%.1f", attendance)
        missedClassLabel.text = missedClasses == 1 ? "Miss a class" : "Miss \(missedClasses) Classes"
        attendedClassLabel.text = attendedClasses == 1 ? "Attend a class" : "Attend \(attendedClasses) Classes"
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        attendedClasses = 0
        missedClasses = 0
        attendClassStepper.value = 0
        missClassStepper.value = 0
        calculateAttendance(missed: 0, attended: 0)
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
