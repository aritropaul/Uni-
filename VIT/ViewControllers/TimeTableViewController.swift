//
//  TimeTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import UIKit
import SPAlert
import PinterestSegment

class TimeTableViewController: UITableViewController {

    var timetable = Timetable()
    @IBOutlet weak var dayBarButton: UIBarButtonItem!
    var day: Days = .mon
    var didGetTimetable = false
    var isLoading = false
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var detailAttendance = [GetAttendanceDetail]()
    var subject = String()
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var menu : PinterestSegment!
    var selectedDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTimeTable()
        self.refreshControl?.addTarget(self, action: #selector(getTimeTable), for: .valueChanged)
        dayBarButton.title = ""
        didGetTimetable = true
        menu = PinterestSegment(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 40), titles: days)
        menu.valueChange = { index in
            self.MenuSelector(day: index)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let currentDay = timetable.currentDay {
            _ = self.TTforDay(day: currentDay)
            print(currentDay)
            self.tableView.reloadData()
        }
    }

    @objc func getTimeTable() {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading timetable")
        VIT.shared.getTimetable { (result) in
            switch result {
            case .success(let timetable) :
                self.timetable = timetable
                DispatchQueue.main.async {
                    _ = self.TTforDay(day: timetable.currentDay!)
                    self.isLoading = false
                    self.tableView.restore()
                    self.tableView.reloadData()
                    if (self.refreshControl?.isRefreshing == true) {
                        self.refreshControl?.endRefreshing()
                    }
                }
            case .failure(let error) :
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }
    }
    
    func TTforDay(day: Days) -> [Day]{
        switch day {
        case .mon:
            self.day = .mon
            return timetable.timeTable?.mon ?? [Day]()
        case .tue:
            self.day = .tue
            return timetable.timeTable?.tue ?? [Day]()
        case .wed:
            self.day = .wed
            return timetable.timeTable?.wed ?? [Day]()
        case .thu:
            self.day = .thu
            return timetable.timeTable?.thu ?? [Day]()
        case .fri:
            self.day = .fri
            return timetable.timeTable?.fri ?? [Day]()
        case .sat:
            self.day = .sat
            return timetable.timeTable?.sat ?? [Day]()
        case .sun:
            self.day = .sun
            return timetable.timeTable?.sun ?? [Day]()
        }
    }
    
    @objc func MenuSelector(day: Int) {
        switch day {
        case 0: self.day = .mon
        case 1: self.day = .tue
        case 2: self.day = .wed
        case 3: self.day = .thu
        case 4: self.day = .fri
        case 5: self.day = .sat
        case 6: self.day = .sun
        default:
            self.day = .mon
        }
        selectedDay = day
        print(day)
        generator.impactOccurred()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let classes = TTforDay(day: day).count
        
        if !isLoading {
            if classes == 0 {
                self.tableView.setEmptyView(title: "No classes today", message: "Any classes for the day will be shown here")
            }
            else {
                self.tableView.restore()
            }
        }
        
        return classes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! ClassTableViewCell
        let today = TTforDay(day: day)
        cell.subject.text = today[indexPath.row].course
        cell.attendanceLabel.text = (today[indexPath.row].attendance ?? "0") + " %"
        let attendance = Int(today[indexPath.row].attendance ?? "0")!
        if attendance >= 75 {
            cell.attendanceLabel.textColor = .systemGreen
        }
        else if attendance >= 70 {
            cell.attendanceLabel.textColor = .systemOrange
        }
        else {
            cell.attendanceLabel.textColor = .systemRed
        }
        cell.slot.text = today[indexPath.row].slot
        if today[indexPath.row].courseType == "ETH" || today[indexPath.row].courseType == "SS" || today[indexPath.row].courseType == "TH" {
            cell.typeImage.image = UIImage(systemName: "book.closed.fill")
        }
        else if today[indexPath.row].courseType == "ELA" || today[indexPath.row].courseType == "LO" {
            cell.typeImage.image = UIImage(systemName: "atom")
        }
        cell.slot.textColor = view.tintColor
        cell.slot.backgroundColor = view.tintColor.withAlphaComponent(0.2)
        cell.timeLabel.text = "\(today[indexPath.row].inTime ?? "") - \(today[indexPath.row].outTime ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let today = TTforDay(day: day)
        let course = today[indexPath.row].course ?? ""
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
            let alarmAction = UIAction(title: "Set a reminder", image: UIImage(systemName: "alarm")) { (action) in
                let formatter = DateFormatter()
                formatter.dateFormat = "E hh:mm a"
                let time = formatter.date(from: self.days[self.selectedDay] + (today[indexPath.row].inTime ?? ""))
                scheduleNotification(course: course, time: time!)
                self.showToast(with: "Reminder Set for \(course.abbr())")
            }
            
            let attendanceAction = UIAction(title: "View Attendance", image: UIImage(systemName: "person.crop.circle.badge.checkmark")) { (action) in
                self.detailAttendance = today[indexPath.row].getAttendanceDetails ?? [GetAttendanceDetail]()
                self.subject = today[indexPath.row].course ?? "Attendance"
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Attendance", sender: Any?.self)
                }
            }
            
            let menu = UIMenu(title: course, children: [alarmAction, attendanceAction])
            return menu
        }
        return configuration
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let today = TTforDay(day: day)
        detailAttendance = today[indexPath.row].getAttendanceDetails ?? [GetAttendanceDetail]()
        subject = today[indexPath.row].course ?? "Attendance"
        self.performSegue(withIdentifier: "Attendance", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attendanceVC = segue.destination as? AttendanceTableViewController {
            attendanceVC.attendanceDetails = detailAttendance
            attendanceVC.subject = subject
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dayView = UIView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.height ?? 44 + 20, width: self.view.frame.width, height: 56))
        dayView.addSubview(menu)
        menu.isUserInteractionEnabled = true
        menu.indicatorColor = .white
//        menu.setSelectIndex(index: selectedDay, animated: true)
        dayView.backgroundColor = .secondarySystemBackground
        return dayView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
}
