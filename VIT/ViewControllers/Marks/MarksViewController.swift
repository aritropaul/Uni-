//
//  MarksViewController.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import UIKit
import SPAlert
import ALRT

class MarksViewController: UITableViewController {

    @IBOutlet weak var semesterButton: UIBarButtonItem!
    
    var semesters: Marks?
    var selectedSem: MarkView?
    var selectedSubject: Subject?
    var isLoading = false
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarks(cached: false)
        self.refreshControl?.addTarget(self, action: #selector(getMarks), for: .valueChanged)
        semesterButton.title = Semesters.FallSemester202021.rawValue
        semesterButton.primaryAction = nil
        semesterButton.menu = makeMenu()
    }
    
    @objc func getMarks(cached: Bool = false) {
        isLoading = true
        self.tableView.setLoadingView(title: "Loading Marks")
        VIT.shared.getMarks(cache: cached) { (result) in
            switch result {
            case .success(let semesters) :
                self.semesters = semesters
                DispatchQueue.main.async {
                    self.selectSem(sem: .FallSemester202021)
                    self.tableView.restore()
                    self.isLoading = false
                    if self.refreshControl?.isRefreshing == true {
                        self.refreshControl?.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.restore()
                    ALRT.create(.alert, title: "Error", message: error.localizedDescription).addAction("Retry", style: .default, preferred: true) { (action, textFields) in
                        self.getMarks()
                    }.addCancel().show()
                }
            }
        }
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
    
    func selectSem(sem: Semesters) {
        switch sem {
        case .FallSemester201718 :
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.FallSemester201718.rawValue
            })
        case .WinterSemester201718:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.WinterSemester201718.rawValue
            })
        case .FallSemester201819:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.FallSemester201819.rawValue
            })
        case .WinterSemester201819:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.WinterSemester201819.rawValue
            })
        case .FallSemester201920:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.FallSemester201920.rawValue
            })
        case .WinterSemester201920:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.WinterSemester201920.rawValue
            })
        case .FallSemester202021:
            self.selectedSem = self.semesters?.markView.first(where: { (sem) -> Bool in
                return sem.name == SemesterMap.FallSemester202021.rawValue
            })
        }
        
        self.tableView.reloadData()
        generator.impactOccurred()
        semesterButton.title = sem.rawValue
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = selectedSem?.subjects.count
        if !isLoading {
            if list == 0 {
                self.tableView.setEmptyView(title: "No marks here", message: "Marks not found for this semester.")
            }
            else {
                self.tableView.restore()
            }
        }
        return list ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markCell", for: indexPath) as! MarksTableViewCell
        cell.courseName.text = selectedSem?.subjects[indexPath.row].title
        cell.courseCode.text = (selectedSem?.subjects[indexPath.row].code ?? "")  + " · " + (courseMap[selectedSem?.subjects[indexPath.row].type ?? ""] ?? "")
        var total = 0.0
        for marks in selectedSem?.subjects[indexPath.row].marks ?? [Mark]() {
            total += marks.weightedMarks
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
        selectedSubject = selectedSem?.subjects[indexPath.row]
        self.performSegue(withIdentifier: "marksDetail", sender: Any?.self)
    }
}
