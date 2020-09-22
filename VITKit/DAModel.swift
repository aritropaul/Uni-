//
//  DAModel.swift
//  VIT
//
//  Created by Aritro Paul on 25/08/20.
//

import Foundation

struct DA: Codable {
    let assignments: [Assignment]
}

// MARK: - Assignment
struct Assignment: Codable {
    let title, lastDate, courseName: String
    let faculty: Faculty
}

// MARK: - Faculty
struct Faculty: Codable {
    let id, name, cabin, designation: String
    let email: String
}
