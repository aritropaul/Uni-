//
//  DAModel.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import Foundation

// MARK: - Assignment
struct Assignment: Codable {
    let assignmentDetail: [AssignmentDetail]
}

// MARK: - AssignmentDetail
struct AssignmentDetail: Codable {
    let getDigitalAssignmentDetails: [GetDigitalAssignmentDetail]?
    let courseType, img, roomNumber, cabin: String?
    let facultyID, semesterID, courseName, classID: String?
    let school, attendanceSlot, facultyName, designation: String?
    let email, classGroupID: String?

    enum CodingKeys: String, CodingKey {
        case getDigitalAssignmentDetails, courseType, img, roomNumber, cabin
        case facultyID = "facultyId"
        case semesterID = "semesterId"
        case courseName
        case classID = "classId"
        case school, attendanceSlot, facultyName, designation, email
        case classGroupID = "classGroupId"
    }
}

// MARK: - GetDigitalAssignmentDetail
struct GetDigitalAssignmentDetail: Codable {
    let optionTitle, lastDate: String?
}


struct DA {
    var assignmentTitle: String?
    var dueDate: String?
    var course: String?
    var facultyMail: String?
}
