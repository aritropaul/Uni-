//
//  DATableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit
import SPAlert
import MessageUI

class DATableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var assignments = [DA]()
    var isLoading = false
    var dateSorted = true
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDA()
        self.refreshControl?.addTarget(self, action: #selector(loadDA), for: .valueChanged)
    }
    
    @IBAction func filter(_ sender: Any) {
        if dateSorted {
            assignments.sort { (da1, da2) -> Bool in
                return (da1.course)! < (da2.course)!
            }
            filterButton.image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
            dateSorted = false
        }
        else {
            assignments.sort { (da1, da2) -> Bool in
                return (da1.dueDate?.toDate())! < (da2.dueDate?.toDate())!
            }
            filterButton.image = UIImage(systemName: "line.horizontal.3.decrease.circle")
            dateSorted = true
        }
        tableView.reloadData()
    }
    
    
    @objc func loadDA() {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Assignments")
        VIT.shared.getDAs { (result) in
            switch result {
            case .success(let assignments) :
                self.isLoading = false
                self.parseDA(assignmentDetail: assignments)
                DispatchQueue.main.async {
                    self.tableView.restore()
                    self.tableView.reloadData()
                    if (self.refreshControl?.isRefreshing == true) {
                        self.refreshControl?.endRefreshing()
                    }
                }
            case .failure( _):
                SPAlert.present(message: "Error", haptic: .error)
            }
        }
    }
    
    
    func parseDA(assignmentDetail: [AssignmentDetail]) {
        for assignment in assignmentDetail {
            for task in assignment.getDigitalAssignmentDetails ?? [GetDigitalAssignmentDetail]() {
                let da = DA(assignmentTitle: task.optionTitle, dueDate: task.lastDate, course: assignment.courseName, facultyMail: assignment.email)
                assignments.append(da)
            }
        }
        
        assignments.sort { (da1, da2) -> Bool in
            return (da1.dueDate?.toDate())! < (da2.dueDate?.toDate())!
        }
    }
    
    func sendEmail(_ to: String, assignment: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
            mail.setSubject(assignment)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent :
                DispatchQueue.main.async {
                    self.showToast(with: "Sent Mail")
                }
            case .failed :
                DispatchQueue.main.async {
                    self.showToast(with: "Failed")
                }
            case .cancelled :
                DispatchQueue.main.async {
                    self.showToast(with: "Cancelled Mail")
                }
            default : break
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoading {
            if assignments.count == 0 {
                self.tableView.setEmptyView(title: "No Assignments", message: "Any DAs will be shown here")
            }
            else {
                self.tableView.restore()
            }
        }

        return assignments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DACell", for: indexPath) as! DATableViewCell
        cell.assignmentTitle.text = assignments[indexPath.row].assignmentTitle
        cell.courseName.text = assignments[indexPath.row].course
        cell.dateLabel.text = assignments[indexPath.row].dueDate?.date()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let course = self.assignments[indexPath.row].course?.components(separatedBy: " - ")[1]
        let task = self.assignments[indexPath.row].assignmentTitle
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let alarmAction = UIAction(title: "Set a reminder", image: UIImage(systemName: "alarm")) { (action) in
                let time = self.assignments[indexPath.row].dueDate?.toDate()
                scheduleDANotification(assignment: task!, course: course!, time: time!)
                self.showToast(with: "Reminder Set for \(course?.abbr() ?? "")")
            }
            
            let attendanceAction = UIAction(title: "Contact Faculty", image: UIImage(systemName: "envelope.fill")) { (action) in
                self.sendEmail(self.assignments[indexPath.row].facultyMail ?? "", assignment: self.assignments[indexPath.row].assignmentTitle ?? "")
            }
            
            let menu = UIMenu(title: task!, children: [alarmAction, attendanceAction])
            return menu
        }
        
        return configuration
    }
}
