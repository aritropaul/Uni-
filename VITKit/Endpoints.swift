//
//  Endpoints.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation

var regNum = "16BME0484"

#if DEBUG
var profileURL = URL(string: "https://vitian-v2.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-v2.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-v2.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-v2.herokuapp.com/grades/\(regNum)")
var DAURL = URL(string: "https://vitian-v2.herokuapp.com/da/\(regNum)")
#else
var profileURL = URL(string: "https://vitian-v2.herokuapp.com/profile/\(regNum)")
var timetableURL = URL(string: "https://vitian-v2.herokuapp.com/timetable/\(regNum)")
var marksURL = URL(string: "https://vitian-v2.herokuapp.com/marks/\(regNum)")
var gradesURL = URL(string: "https://vitian-v2.herokuapp.com/grades/\(regNum)")
var DAURL = URL(string: "https://vitian-v2.herokuapp.com/da/\(regNum)")
#endif

let dataCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
