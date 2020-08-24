//
//  Endpoints.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation

var regNum = "18BEE0069"

var profileURL = URL(string: "https://vitian-wrapper.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-wrapper.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-wrapper.herokuapp.com/marks/\(regNum)")

func generateURLs() {
    profileURL = URL(string: "https://vitian-wrapper.herokuapp.com/profile/\(regNum)")
    timetableURL = URL(string: "https://vitian-wrapper.herokuapp.com/timetable/\(regNum)")
    marksURL = URL(string: "https://vitian-wrapper.herokuapp.com/marks/\(regNum)")
}
