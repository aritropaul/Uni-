//
//  MarksModel.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation

enum Semesters : String, CaseIterable {
    case FallSemester201718 = "FS 2017-18"
    case WinterSemester201718 = "WS 2017-18"
    case FallSemester201819 = "FS 2018-19"
    case WinterSemester201819 = "WS 2018-19"
    case FallSemester201920 = "FS 2019-20"
    case WinterSemester201920 = "WS 2019-20"
    case FallSemester202021 = "FS 2020-21"
}

enum SemesterMap : String, CaseIterable {
    case FallSemester201819 = "VL2018191|Fall Semester 2018-19"
    case WinterSemester201819 = "VL2018195|Winter Semester 2018-19"
    case WinterSemester201920 = "VL2019205|Winter Semester 2019-20"
    case FallSemester201920 = "VL2019201|Fall Semester 2019-20"
    case FallSemester201718 = "VL2017181|Fall Semester 2017-18"
    case WinterSemester201718 = "VL2017185|Winter Semester 2017-18"
    case FallSemester202021 = "VL20202101|Fall Semester 2020-21"
}

struct Marks: Codable {
    let markView: [MarkView]
}

// MARK: - MarkView
struct MarkView: Codable {
    let subjects: [Subject]
    let name: String
}

// MARK: - Subject
struct Subject: Codable {
    let type: String
    let credits: Int
    let code, faculty, title, slot: String
    let marks: [Mark]
}

// MARK: - Mark
struct Mark: Codable {
    let weightedMarks, actualMarks: Double
    let maxMarks: Int
    let title: String
    let weightage: Int
}


let courseMap = [
    "Embedded Theory" : "ETH",
    "Embedded Project" : "EPR",
    "Embedded Lab" : "ELA",
    "Project" : "P",
    "Theory Only" : "TO",
    "Lab Only": "LO",
    "Soft Skill" : "SS"
]
