//
//  GradesModel.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import Foundation

// MARK: - Grades
struct Grades: Codable {
    let grades: [Semester]
}

// MARK: - GradesGrade
struct Semester: Codable {
    let grades: [Grade]
    let name: String
}

// MARK: - GradeGradeClass
struct Grade: Codable {
    let type: String
    let code, title, slot: String
    let marks: [Mark]?
    let grade: String
    let credits: Int
    let range: [String: Double]?
    let gradingType: String
    let grandTotal: Int
}

let gradeMap = ["S" : 10,
                "A" : 9,
                "B" : 8,
                "C" : 7,
                "D" : 6,
                "E" : 5,
                "F" : 4,
                "N" : 0]
