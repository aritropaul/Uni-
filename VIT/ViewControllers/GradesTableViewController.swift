//
//  GradesTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit

class GradesTableViewController: UITableViewController {

    var grades: Grades?
    var selectedSemester = SemesterMap.WinterSemester201920.rawValue
    var isLoading = false
    var selectedSubject : GradeMarkView!
    
    @IBOutlet weak var semesterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGrades()
        semesterButton.menu = menuBuilder()
        semesterButton.primaryAction = nil
        semesterButton.title = Semesters.WinterSemester201920.rawValue
    }
    
    func getGrades() {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Grades")
        VIT.shared.getGrades { (result) in
            switch result {
            case .success(let grades):
                self.isLoading = false
                self.grades = grades
                DispatchQueue.main.async {
                    self.tableView.restore()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
                
        }
    }
    
    func menuBuilder() -> UIMenu {
        var actions = [UIAction]()
        for sem in Semesters.allCases.reversed() {
            let action = UIAction(title: sem.rawValue) { (action) in
                self.selectSem(sem: sem)
            }
            actions.append(action)
        }
        let menu = UIMenu(title: "Semesters", image: UIImage(systemName: "calendar"), options: .displayInline , children: actions)
        return menu
    }
    
    
    func selectSem(sem: Semesters) {
        switch sem {
        case .FallSemester201718:
            selectedSemester = SemesterMap.FallSemester201718.rawValue
        case .WinterSemester201718:
            selectedSemester = SemesterMap.WinterSemester201718.rawValue
        case .FallSemester201819:
            selectedSemester = SemesterMap.FallSemester201819.rawValue
        case .WinterSemester201819:
            selectedSemester = SemesterMap.WinterSemester201819.rawValue
        case .FallSemester201920:
            selectedSemester = SemesterMap.FallSemester201920.rawValue
        case .WinterSemester201920:
            selectedSemester = SemesterMap.WinterSemester201920.rawValue
        case .FallSemester202021:
            selectedSemester = SemesterMap.FallSemester202021.rawValue
        }
        semesterButton.title = sem.rawValue
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoading {
            if grades?.gradeView?[selectedSemester]?.markView?.count ?? 0 == 0 {
                self.tableView.setEmptyView(title: "No Grades Here", message: "No Grades found for this sem")
            }
            else {
                self.tableView.restore()
            }
        }
        return grades?.gradeView?[selectedSemester]?.markView?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
        let subject = grades?.gradeView?[selectedSemester]?.markView?[indexPath.row]
        cell.courseCode.text = subject?.courseCode
        cell.courseName.text = subject?.courseTitle
        cell.gradeLabel.text = subject?.grade
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let subject = grades?.gradeView?[selectedSemester]?.markView?[indexPath.row]
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                let items = ["I got a \(subject?.grade ?? "") in \(subject?.courseTitle ?? "")! What did you get?"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            
            let menu = UIMenu(title: "\(subject?.grade ?? "") in \(subject?.courseTitle ?? "")", children: [shareAction])
            return menu
        }
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubject = grades?.gradeView?[selectedSemester]?.markView?[indexPath.row]
        self.performSegue(withIdentifier: "gradeDetail", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gradeDetailVC = segue.destination as? GradeDetailTableViewController {
            gradeDetailVC.gradeDetails = selectedSubject
        }
    }
    
}
