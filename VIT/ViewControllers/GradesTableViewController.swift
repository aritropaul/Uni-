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
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var selectedSubject : GradeMarkView!
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
        getGrades()
        semesterButton.menu = menuBuilder()
        semesterButton.primaryAction = nil
        semesterButton.title = Semesters.WinterSemester201920.rawValue
        CGPALabel.text = ""
        semGPALabel.text = ""
        
        let interaction = UIContextMenuInteraction(delegate: self)
        GPAView.addInteraction(interaction)
    }
    
    func calculateCGPA() {
        for (_, value) in self.grades?.gradeView ?? [String : GradeView]() {
            for subject in value.markView ?? [GradeMarkView]() {
                if subject.grade != "P" {
                    cgpa += Double((subject.c ?? 0) * (gradeMap[subject.grade!] ?? 0))
                    totalCredits += subject.c ?? 1
                }
            }
        }
        cgpa = cgpa / Double(totalCredits)
        CGPALabel.text = String(format: "%.2f", cgpa)
    }
    
    func calculateGPA(sem: String) {
        gpa = 0.0
        semCredits = 0
        let subject = self.grades?.gradeView?[sem]
        for item in subject?.markView ?? [GradeMarkView]() {
            if item.grade != "P" {
                gpa += Double((item.c ?? 0) * (gradeMap[item.grade!] ?? 0))
                semCredits += item.c ?? 1
            }
        }
        
        gpa = gpa / Double(semCredits)
        semGPALabel.text = String(format: "%.2f", gpa)
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
                    self.calculateCGPA()
                    self.calculateGPA(sem: self.selectedSemester)
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
        self.calculateGPA(sem: selectedSemester)
        generator.impactOccurred()
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
