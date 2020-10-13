//
//  DATableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit
import SPAlert
import MessageUI
import ALRT

class DATableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var assignments = [Assignment]()
    var allAssignments = [Assignment]()
    var isLoading = false
    var dateSorted = true
    @IBOutlet weak var filterButton: UIBarButtonItem!
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadDA(cached: true)
        loadDA(cached: false)
        self.refreshControl?.addTarget(self, action: #selector(loadDA), for: .valueChanged)
    }
    
    @IBAction func filter(_ sender: Any) {
        if dateSorted {
            assignments = assignments.filter { (da) -> Bool in
                return (da.lastDate.toDate())! > Date()
            }
            showToast(with: "Only Remaining DAs")
            filterButton.image = UIImage(systemName: "calendar.circle.fill")
            dateSorted = false
        }
        else {
            assignments = allAssignments
            assignments.sort { (da1, da2) -> Bool in
                return (da1.lastDate.toDate())! < (da2.lastDate.toDate())!
            }
            showToast(with: "All Assignments")
            filterButton.image = UIImage(systemName: "calendar.circle")
            dateSorted = true
        }
        tableView.reloadData()
    }
    
    
    @objc func loadDA(cached: Bool = false) {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Assignments")
        VIT.shared.getDAs(cache: cached) { (result) in
            switch result {
            case .success(let assignments) :
                self.isLoading = false
                self.assignments = assignments
                self.allAssignments = assignments
                self.assignments.sort { (da1, da2) -> Bool in
                    return (da1.lastDate.toDate())! < (da2.lastDate.toDate())!
                }
                DispatchQueue.main.async {
                    self.tableView.restore()
                    self.tableView.reloadData()
                    self.generator.impactOccurred()
                    if (self.refreshControl?.isRefreshing == true) {
                        self.refreshControl?.endRefreshing()
                    }
                }
            case .failure( let error ):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.restore()
                    ALRT.create(.alert, title: "Error", message: error.localizedDescription).addAction("Retry", style: .default, preferred: true) { (action, textFields) in
                        self.loadDA()
                    }.addCancel().show()
                }
            }
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
        cell.assignmentTitle.text = assignments[indexPath.row].title
        cell.courseName.text = assignments[indexPath.row].courseName
        cell.dateLabel.text = assignments[indexPath.row].lastDate.date()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let course = self.assignments[indexPath.row].courseName.components(separatedBy: " - ")[1]
        let task = self.assignments[indexPath.row].title
        let identifier = NSString(string: "\(indexPath.row)")
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { (action) -> UIMenu? in
            let alarmAction = UIAction(title: "Set a reminder", image: UIImage(systemName: "alarm"), discoverabilityTitle: self.getDaysLeft(indexPath: indexPath)) { (action) in
                let time = self.assignments[indexPath.row].lastDate.toDate()
                scheduleDANotification(assignment: task, course: course, time: time!)
                self.generator.impactOccurred()
                self.showToast(with: "Reminder Set for \(course.abbr())")
            }
            
            let attendanceAction = UIAction(title: "Contact Faculty", image: UIImage(systemName: "envelope.fill"), discoverabilityTitle: self.assignments[indexPath.row].faculty.email) { (action) in
                self.sendEmail(self.assignments[indexPath.row].faculty.email , assignment: self.assignments[indexPath.row].title )
                self.generator.impactOccurred()
            }
            
            let menu = UIMenu(title: task, children: [alarmAction, attendanceAction])
            return menu
        }
        
        return configuration
    }
    
    func getDaysLeft(indexPath: IndexPath) -> String {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.day, .hour]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        var daysLeft =  dateComponentsFormatter.string(from: (self.assignments[indexPath.row].lastDate.toDate()?.removing(days: -1))!, to: Date())
        if daysLeft!.contains("-") || daysLeft!.contains("hour") {
            daysLeft = "Due in " + daysLeft!.replacingOccurrences(of: "-", with: "")
        }
        else {
            daysLeft = "Deadline has passed"
        }
        return daysLeft ?? ""
    }
    
    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let index = Int(configuration.identifier as! String) ?? -1
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        let params = UIPreviewParameters()
        params.visiblePath = UIBezierPath(roundedRect: cell?.bounds ?? CGRect(), cornerRadius: 12)
        params.backgroundColor = .clear
        return UITargetedPreview(view: cell ?? DATableViewCell(), parameters: params)
    }
}
