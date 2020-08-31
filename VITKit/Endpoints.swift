//
//  Endpoints.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation

var regNum = "18BEE0069"

#if DEBUG
var profileURL = URL(string: "https://vitian-wrapper-debug.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-wrapper-debug.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-wrapper-debug.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-wrapper-debug.herokuapp.com/grade/\(regNum)")
var DAURL = URL(string: "https://vitian-wrapper-debug.herokuapp.com/da/\(regNum)")
#else
var profileURL = URL(string: "https://vitian-wrapper.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-wrapper.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-wrapper.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-wrapper.herokuapp.com/grade/\(regNum)")
var DAURL = URL(string: "https://vitian-wrapper.herokuapp.com/da/\(regNum)")
#endif

func generateURLs() {
    profileURL = URL(string: "https://vitian-wrapper.herokuapp.com/profile/\(regNum)")
    timetableURL = URL(string: "https://vitian-wrapper.herokuapp.com/timetable/\(regNum)")
    marksURL = URL(string: "https://vitian-wrapper.herokuapp.com/marks/\(regNum)")
}

let dataCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
