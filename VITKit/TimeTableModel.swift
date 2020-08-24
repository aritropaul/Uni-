//
//  TimeTableModel.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import Foundation

struct Timetable: Codable {
    var currentDay: Days?
    var timeTable: TimeTable?
}

enum Days: String, Codable, CaseIterable {
    case mon = "MON"
    case tue = "TUE"
    case wed = "WED"
    case thu = "THU"
    case fri = "FRI"
    case sat = "SAT"
    case sun = "SUN"
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}


// MARK: - TimeTable
struct TimeTable: Codable {
    var mon, tue, wed, thu, fri, sat, sun: [Day]?

    enum CodingKeys: String, CodingKey {
        case mon = "MON"
        case tue = "TUE"
        case wed = "WED"
        case thu = "THU"
        case fri = "FRI"
        case sat = "SAT"
        case sun = "SUN"
    }
}

// MARK: - Mon
struct Day: Codable {
    var venue: String?
    var courseType, studentUnits, patternID: String?
    var slot: String?
    var totalUnits, inTime, semesterID, classID: String?
    var currentDay: String?
    var attendanceSlot: String?
    var name: String?
    var course, outTime, attendance: String?
    var getAttendanceDetails: [GetAttendanceDetail]?

    enum CodingKeys: String, CodingKey {
        case venue, courseType, studentUnits
        case patternID = "patternId"
        case slot, totalUnits, inTime
        case semesterID = "semesterId"
        case classID = "classId"
        case currentDay, attendanceSlot, name, course, outTime, attendance, getAttendanceDetails
    }
}

// MARK: - GetAttendanceDetail
struct GetAttendanceDetail: Codable {
    var attendanceSlot: String?
    var attendanceDay: Days?
    var attendanceDate: String?
    var attendanceStatus: AttendanceStatus?
    var classTime: String?
}

enum AttendanceStatus: String, Codable {
    case onDuty = "On Duty"
    case present = "Present"
    case absent = "Absent"
}
