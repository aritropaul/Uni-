//
//  MarksDetailViewController.swift
//  VIT
//
//  Created by Aritro Paul on 27/07/20.
//

import UIKit

let colorArray = ["#c0bda5ff","#cc978eff","#f39c6bff","#ff3864ff","#261447ff","#9b97b2ff","#fde12dff","#c200fbff","#233d4dff","#fe7f2dff"]


class MarksDetailViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var marksTable: UITableView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var courseType: UILabel!
    
    var subject = MarksList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseName.text = subject.courseTitle
        courseType.text = courseMap[subject.courseType ?? ""]
        teacherName.text = subject.faculty
        courseCode.text = subject.courseCode
        mainView.layer.cornerRadius = 12
        barView.layer.cornerRadius = 12
        marksTable.delegate = self
        marksTable.dataSource = self
        self.navigationItem.title = subject.courseTitle
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        generateBar()
    }
    
    func generateBar() {
        var total = 0.0
        var index = 0
        for mark in subject.studentMarkList ?? [StudentMarkList]() {
            let view = UIView(frame: barView.bounds)
            view.frame.size.width = 0
            UIView.animate(withDuration: 0.2) {
                view.frame.size.width = CGFloat(total) + (CGFloat((mark.weightageMarkView ?? 0.0)) * self.barView.frame.width / 100)
            }
            total = total + ((mark.weightageMarkView ?? 0.0) * Double(barView.frame.width) / 100)
            view.backgroundColor = UIColor(hex: colorArray.reversed()[index])
            if index != colorArray.count - 1 {
                index = index + 1
            }
            else {
                index = 0
            }
            view.layer.cornerRadius = 12
            view.layoutIfNeeded()
            barView.addSubview(view)
            barView.sendSubviewToBack(view)
        }
    }
    

}

extension MarksDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.studentMarkList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markCell")!
        cell.textLabel?.text = subject.studentMarkList?[indexPath.row].markTitle
        cell.detailTextLabel?.text = "\(subject.studentMarkList?[indexPath.row].marksGiven ?? 0.0) / \(subject.studentMarkList?[indexPath.row].maxMark ?? "0")"
        return cell
    }
    
    
}
