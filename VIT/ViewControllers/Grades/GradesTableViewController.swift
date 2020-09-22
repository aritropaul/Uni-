//
//  GradesTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import UIKit
import SPAlert
import ALRT

class GradesTableViewController: UITableViewController {

    var grades: Grades?
    var selectedSemester: Semester?
    var selectedSemesterString = SemesterMap.WinterSemester201920.rawValue
    var isLoading = false
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var selectedSubject : Grade!
    var cgpa = 0.0
    var totalCredits = 0
    var gpa = 0.0
    var semCredits = 0
    
    @IBOutlet weak var GPAView: UIView!
    @IBOutlet weak var CGPALabel: UILabel!
    @IBOutlet weak var semGPALabel: UILabel!
    
    @IBOutlet weak var semesterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGrades(cached: true)
        self.refreshControl?.addTarget(self, action: #selector(getGrades(cached:)), for: .valueChanged)
        semesterButton.menu = menuBuilder()
        semesterButton.primaryAction = nil
        selectSem(sem: .WinterSemester201920)
        CGPALabel.text = ""
        semGPALabel.text = ""
        let interaction = UIContextMenuInteraction(delegate: self)
        GPAView.addInteraction(interaction)
    }
    
    func calculateCGPA() {
        cgpa = 0.0
        totalCredits = 0
        for semester in self.grades?.grades ?? [Semester]() {
            for subject in semester.grades {
                if subject.grade != "P" {
                    cgpa += Double((subject.credits) * (gradeMap[subject.grade] ?? 0))
                    totalCredits += subject.credits
                }
            }
        }
        cgpa = cgpa / Double(totalCredits)
        CGPALabel.text = String(format: "%.2f", cgpa)
    }
    
    func calculateGPA(sem: String) {
        gpa = 0.0
        semCredits = 0
        let sem = selectedSemester
        for item in sem?.grades ?? [Grade]() {
            if item.grade != "P" {
                gpa += Double((item.credits ) * (gradeMap[item.grade] ?? 0))
                semCredits += item.credits
            }
        }
        
        gpa = gpa / Double(semCredits)
        semGPALabel.text = String(format: "%.2f", gpa)
    }
    
    @objc func getGrades(cached: Bool = false) {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Grades")
        VIT.shared.getGrades(cache: cached) { (result) in
            switch result {
            case .success(let grades):
                self.isLoading = false
                self.grades = grades
                DispatchQueue.main.async {
                    self.calculateCGPA()
                    if self.refreshControl!.isRefreshing {
                        self.refreshControl?.endRefreshing()
                    }
                    self.calculateGPA(sem: self.selectedSemesterString)
                    self.tableView.restore()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.restore()
                    ALRT.create(.alert, title: "Error", message: error.localizedDescription).addAction("Retry", style: .default, preferred: true) { (action, textFields) in
                        self.getGrades()
                    }.addCancel().show()
                }
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
            selectedSemesterString = SemesterMap.FallSemester201718.rawValue
        case .WinterSemester201718:
            selectedSemesterString = SemesterMap.WinterSemester201718.rawValue
        case .FallSemester201819:
            selectedSemesterString = SemesterMap.FallSemester201819.rawValue
        case .WinterSemester201819:
            selectedSemesterString = SemesterMap.WinterSemester201819.rawValue
        case .FallSemester201920:
            selectedSemesterString = SemesterMap.FallSemester201920.rawValue
        case .WinterSemester201920:
            selectedSemesterString = SemesterMap.WinterSemester201920.rawValue
        case .FallSemester202021:
            selectedSemesterString = SemesterMap.FallSemester202021.rawValue
        }
        selectedSemester = grades?.grades.first(where: { (sem) -> Bool in
            return sem.name == selectedSemesterString
        })
        semesterButton.title = sem.rawValue
        self.calculateGPA(sem: selectedSemesterString)
        generator.impactOccurred()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoading {
            if selectedSemester?.grades.count ?? 0 == 0 {
                self.tableView.setEmptyView(title: "No Grades Here", message: "No Grades found for this sem")
            }
            else {
                self.tableView.restore()
            }
        }
        return selectedSemester?.grades.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
        let subject = selectedSemester?.grades[indexPath.row]
        cell.courseCode.text = subject?.code
        cell.courseName.text = subject?.title
        cell.gradeLabel.text = subject?.grade
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let subject = selectedSemester?.grades[indexPath.row]
        let identifier = NSString(string: "\(indexPath.row)")
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { (action) -> UIMenu? in
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                let items = ["I got a \(subject?.grade ?? "") in \(subject?.title ?? "")! What did you get?"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            
            let menu = UIMenu(title: "\(subject?.grade ?? "") in \(subject?.title ?? "")", children: [shareAction])
            return menu
        }
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let index = Int(configuration.identifier as! String) ?? -1
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        let params = UIPreviewParameters()
        params.visiblePath = UIBezierPath(roundedRect: cell?.bounds ?? CGRect(), cornerRadius: 12)
        params.backgroundColor = .clear
        return UITargetedPreview(view: cell ?? GradeTableViewCell(), parameters: params)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubject = selectedSemester?.grades[indexPath.row]
        self.performSegue(withIdentifier: "gradeDetail", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gradeDetailVC = segue.destination as? GradeDetailTableViewController {
            gradeDetailVC.gradeDetails = selectedSubject
        }
    }
    
}

extension GradesTableViewController : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let shareGPAAction = UIAction(title: "Share GPA", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                let items = ["I got " + String(format: "%.2f", self.gpa) + " GPA this sem! Can you beat it?"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            
            let shareCGPAAction = UIAction(title: "Share CGPA", image: UIImage(systemName: "square.and.arrow.up.on.square")) { (action) in
                let items = ["My CGPA is now " + String(format: "%.2f", self.cgpa) + " ! Yay!"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            
            let menu = UIMenu(title: "GPA", children: [shareGPAAction, shareCGPAAction])
            return menu
            
        }
        
        return configuration
    }
}
