//
//  GradesModel.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import Foundation

struct Grades : Codable {
    let gradeView: [String: GradeView]?
}

struct GradeView : Codable {
    let markView: [GradeMarkView]?
}

struct GradeMarkView : Codable {
    let courseCode: String?
    let courseTitle: String?
    let studentMarkListByClassNbr: [String : [GradeStudentMarkList]]?
    let c: Int?
    let grade: String?
    let grandTotal : Int?
}

struct GradeStudentMarkList : Codable {
    let markTitle: String?
    let maxMark : String?
    let marksGiven: Double?
}

let gradeMap = ["S" : 10,
                "A" : 9,
                "B" : 8,
                "C" : 7,
                "D" : 6,
                "E" : 5,
                "F" : 4,
                "N" : 0]
