//
//  GradeDetailTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 26/08/20.
//

import UIKit

class GradeDetailTableViewController: UITableViewController {

    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var gradeDetails : Grade!
    var marksList : [Mark]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gradeDetails.title.abbr()
        gradeLabel.text = gradeDetails.grade
        totalLabel.text = "\(gradeDetails.grandTotal)"
        marksList = gradeDetails.marks
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marksList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeMarkCell", for: indexPath) as! GradeMarksTableViewCell
        guard let marksList = marksList else { return UITableViewCell() }
        let item = marksList[indexPath.row]
        cell.setMarks(for: item.title, marksGiven: item.actualMarks, maxMarks: item.maxMarks)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
