//
//  MarksViewController.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import UIKit
import SPAlert

class MarksViewController: UITableViewController {

    @IBOutlet weak var semesterButton: UIBarButtonItem!
    
    var marks = Marks()
    var marksList = [MarksList]()
    var selectedSubject = MarksList()
    var sem = [String : MarksList]()
    var isLoading = false
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarks()
        self.refreshControl?.addTarget(self, action: #selector(getMarks), for: .valueChanged)
        semesterButton.title = Semesters.WinterSemester201920.rawValue
        semesterButton.primaryAction = nil
        semesterButton.menu = makeMenu()
        
    }
    
    @objc func getMarks() {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Marks")
        VIT.shared.getMarks { (result) in
            switch result {
            case .success(let marks) :
                self.marks = marks
                self.sem = marks.markView?.WinterSemester201920 ?? [String: MarksList]()
                self.semesterButton.title = Semesters.WinterSemester201920.rawValue
                self.marksList = [MarksList]()
                for (_, value) in self.sem {
                    self.marksList.append(value)
                }
                self.marksList.sort { (marks1, marks2) -> Bool in
                    return (marks1.courseCode ?? "") < (marks2.courseCode ?? "")
                }
                DispatchQueue.main.async {
//                    self.selectSem(sem: .WinterSemester201920)
                    self.tableView.restore()
                    self.isLoading = false
                    if self.refreshControl?.isRefreshing == true {
                        self.refreshControl?.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error) :
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }
    }
    
    func selectSem(sem: Semesters) {
        marksList = [MarksList]()
        switch sem {
        case .FallSemester201718:
            self.sem = marks.markView?.FallSemester201718 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.FallSemester201718.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .WinterSemester201718:
            self.sem = marks.markView?.WinterSemester201718 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.WinterSemester201718.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .FallSemester201819:
            self.sem = marks.markView?.FallSemester201819 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.FallSemester201819.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .WinterSemester201819:
            self.sem = marks.markView?.WinterSemester201819 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.WinterSemester201819.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .FallSemester201920:
            self.sem = marks.markView?.FallSemester201920 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.FallSemester201920.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .WinterSemester201920:
            self.sem = marks.markView?.WinterSemester201920 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.WinterSemester201920.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        case .FallSemester202021:
            self.sem = marks.markView?.FallSemester202021 ?? [String: MarksList]()
            self.semesterButton.title = Semesters.FallSemester202021.rawValue
            for (_, value) in self.sem {
                self.marksList.append(value)
            }
        }
        generator.impactOccurred()
        self.tableView.reloadData()
    }
    
    func makeMenu() -> UIMenu {
        var actions = [UIAction]()
        for sem in Semesters.allCases.reversed() {
            let action = UIAction(title: sem.rawValue) { (action) in
                print("Selected \(sem)")
                self.selectSem(sem: sem)
            }
            actions.append(action)
        }
        let menu = UIMenu(title: "Semesters", image: UIImage(systemName: "calendar"), options: .displayInline , children: actions)
        return menu
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = marksList.count
        if !isLoading {
            if list == 0 {
                self.tableView.setEmptyView(title: "No marks here", message: "Marks not found for this semester.")
            }
            else {
                self.tableView.restore()
            }
        }
        return list
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markCell", for: indexPath) as! MarksTableViewCell
        cell.courseName.text = marksList[indexPath.row].courseTitle
        cell.courseCode.text = (marksList[indexPath.row].courseCode ?? "")  + " · " + (courseMap[marksList[indexPath.row].courseType ?? ""] ?? "")
        var total = 0.0
        for marks in marksList[indexPath.row].studentMarkList ?? [StudentMarkList]() {
            total += marks.weightageMarkView ?? 0.0
        }
        cell.total.text = String(format: "%.2f", total)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MarksDetailViewController {
            detailVC.subject = selectedSubject
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubject = marksList[indexPath.row]
        self.performSegue(withIdentifier: "marksDetail", sender: Any?.self)
    }
}
