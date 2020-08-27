//
//  APIHandler.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import Foundation


class VIT {
    static let shared = VIT()
    static var loggedIn = false
    
    func getMobileNumber(completion: @escaping(Result<String, Error>)->Void) {
        getProfile { (result) in
            switch result {
                case .success(let profile) : completion(.success(profile.mobileNo ?? ""))
                case .failure(let error) : completion(.failure(error))
            }
        }
    }
    
    func getProfile(completion: @escaping(Result<Profile, Error>)->Void) {
        print("⤵️ Getting Profile")
        guard let url = profileURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let profile = try! JSONDecoder().decode(Profile.self, from: data)
                    print("✅ Profile Success")
                    completion(.success(profile))
                }
            }
            else {
                print("❌ Profile Failure")
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    func getTimetable(completion: @escaping(Result<Timetable, Error>)->Void) {
        print("⤵️ Getting Timetable")
        guard let url = timetableURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    if let timetable = try? JSONDecoder().decode(Timetable.self, from: data) {
                        print("✅ Timetable Success")
                        completion(.success(timetable))
                    }
                    else {
                        print("❌ Timetable Failure")
                        completion(.failure(error!))
                    }
                    
                }
            }
            else {
                print("❌ Timetable Failure")
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    func getMarks(completion: @escaping(Result<Marks, Error>)->Void) {
        print("⤵️ Getting Marks")
        guard let url = marksURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let marks = try! JSONDecoder().decode(Marks.self, from: data)
                    print("✅ Marks Success")
                    completion(.success(marks))
                }
            }
            else {
                print("❌ Marks Failure")
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    func getDAs(completion: @escaping(Result<[AssignmentDetail], Error>)->Void) {
        print("⤵️ Getting DAs")
        guard let url = DAURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let assignment = try! JSONDecoder().decode(Assignment.self, from: data)
                    print("✅ DA Success")
                    completion(.success(assignment.assignmentDetail))
                }
            }
            else {
                print("❌ DA Failure")
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    func getGrades(completion: @escaping(Result<Grades, Error>)->Void) {
        print("⤵️ Getting Grades")
        guard let url = gradesURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let grades = try! JSONDecoder().decode(Grades.self, from: data)
                    print("✅ Grades Success")
                    completion(.success(grades))
                }
            }
            else {
                print("❌ Grades Failure")
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    
    func saveLoginState() {
        UserDefaults.standard.set(VIT.loggedIn, forKey: "login")
        UserDefaults.standard.set(regNum, forKey: "regno")
    }
    
    func fetchLoginState() -> Bool{
        VIT.loggedIn = UserDefaults.standard.bool(forKey: "login")
        regNum = UserDefaults.standard.string(forKey: "regno") ?? ""
        return VIT.loggedIn
    }
}
