//
//  Endpoints.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation

var regNum = ""

#if DEBUG
var profileURL = URL(string: "https://vitian-v2.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-v2.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-v2.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-v2.herokuapp.com/grades/\(regNum)")
var DAURL = URL(string: "https://vitian-v2.herokuapp.com/da/\(regNum)")
var upcomingURL = URL(string: "https://vitian-v2.herokuapp.com/upcoming/\(regNum)")
#else
var profileURL = URL(string: "https://vitian-v2.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-v2.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-v2.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-v2.herokuapp.com/grades/\(regNum)")
var DAURL = URL(string: "https://vitian-v2.herokuapp.com/da/\(regNum)")
var upcomingURL = URL(string: "https://vitian-v2.herokuapp.com/upcoming/\(regNum)")
#endif

func generateURL() {
    profileURL = URL(string: "https://vitian-v2.herokuapp.com/profile/\(regNum)")
    timetableURL = URL(string: "https://vitian-v2.herokuapp.com/timetable/\(regNum)")
    marksURL = URL(string: "https://vitian-v2.herokuapp.com/marks/\(regNum)")
    gradesURL = URL(string: "https://vitian-v2.herokuapp.com/grades/\(regNum)")
    DAURL = URL(string: "https://vitian-v2.herokuapp.com/da/\(regNum)")
    upcomingURL = URL(string: "https://vitian-v2.herokuapp.com/upcoming/\(regNum)")
}

let dataCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
