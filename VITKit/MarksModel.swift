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

struct Marks: Codable {
    var markView: MarkView?
}

// MARK: - MarkView
struct MarkView: Codable {
        var FallSemester201819, WinterSemester201819, WinterSemester201920, FallSemester201920, FallSemester201718, WinterSemester201718, FallSemester202021: [String: MarksList]?

        enum CodingKeys: String, CodingKey {
            case FallSemester201819 = "VL2018191|Fall Semester 2018-19"
            case WinterSemester201819 = "VL2018195|Winter Semester 2018-19"
            case WinterSemester201920 = "VL2019205|Winter Semester 2019-20"
            case FallSemester201920 = "VL2019201|Fall Semester 2019-20"
            case FallSemester201718 = "VL2017181|Fall Semester 2017-18"
            case WinterSemester201718 = "VL2017185|Winter Semester 2017-18"
            case FallSemester202021 = "VL20202101|Fall Semester 2020-21"
        }
}

// MARK: - MarksList
struct MarksList: Codable {
    var courseType: String?
    var classNbr: String?
    var c: Int?
    var courseCode: String?
    var courseMode: String?
    var j, l: Int?
    var courseSystem: String?
    var faculty: String?
    var studentMarkList: [StudentMarkList]?
    var courseTitle, slotName: String?
    var p: Int?
    var t: Int?
    var excelUploadFlag: Bool?
    
}


// MARK: - StudentMarkList
struct StudentMarkList: Codable {
    var remark: String?
    var weightageMarkView: Double?
    var marksGiven: Double?
    var maxMark: String?
    var markTitle: String?
    var weightagePercent: Int?
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
