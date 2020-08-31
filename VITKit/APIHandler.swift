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
    
    func getMobileNumber(completion: @escaping(Result<String, APIError>)->Void) {
        getProfile { (result) in
            switch result {
                case .success(let profile) : completion(.success(profile.mobileNo ?? ""))
                case .failure(let error) : completion(.failure(error))
            }
        }
    }
    
    func getProfile(completion: @escaping(Result<Profile, APIError>)->Void) {
        print("⤵️ Getting Profile")
        guard let url = profileURL else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        let session = URLSession.shared
        if let cachedProfile = dataCache.cachedResponse(for: request) {
            let profile = try! JSONDecoder().decode(Profile.self, from: cachedProfile.data)
            print("✅ Profile Success")
            completion(.success(profile))
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let profile = try! JSONDecoder().decode(Profile.self, from: data)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    dataCache.storeCachedResponse(cachedData, for: request)
                    print("✅ Profile Success")
                    completion(.success(profile))
                }
                else if response.statusCode == 429 {
                    print("❌ Profile Failure")
                    completion(.failure(.tooManyRequests(message: "Try again later")))
                }
            }
            else {
                print("❌ Profile Failure")
                completion(.failure(.noResponse(message: "Did not get a response")))
            }
        }
        task.resume()
    }
    
    func getTimetable(cache: Bool = true, completion: @escaping(Result<Timetable, APIError>)->Void) {
        print("⤵️ Getting Timetable")
        guard let url = timetableURL else { return }
        let session = URLSession.shared
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        if let cachedData = dataCache.cachedResponse(for: request) {
            if cache == true {
                if let timetable = try? JSONDecoder().decode(Timetable.self, from: cachedData.data) {
                    print("✅ Timetable Success")
                    completion(.success(timetable))
                }
                else {
                    print("❌ Timetable Failure")
                    completion(.failure(.decodingError(message: "Couldn't get timetable")))
                }
            }
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    if let timetable = try? JSONDecoder().decode(Timetable.self, from: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        dataCache.storeCachedResponse(cachedData, for: request)
                        print("✅ Timetable Success")
                        completion(.success(timetable))
                    }
                    else {
                        print("❌ Timetable Failure")
                        completion(.failure(.decodingError(message: "Couldn't get timetable")))
                    }
                }
                else if response.statusCode == 429 {
                    print("❌ Timetable Failure")
                    completion(.failure(.tooManyRequests(message: "Try again later")))
                }
            }
            else {
                print("❌ Timetable Failure")
                completion(.failure(.noResponse(message: "Did not get a response")))
            }
        }
        task.resume()
    }
    
    func getMarks(cache: Bool = true, completion: @escaping(Result<Marks, APIError>)->Void) {
        print("⤵️ Getting Marks")
        guard let url = marksURL else { return }
        let session = URLSession.shared
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        if let cachedData = dataCache.cachedResponse(for: request) {
            if cache == true {
                let marks = try! JSONDecoder().decode(Marks.self, from: cachedData.data)
                print("✅ Marks Success")
                completion(.success(marks))
            }
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let marks = try! JSONDecoder().decode(Marks.self, from: data)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    dataCache.storeCachedResponse(cachedData, for: request)
                    print("✅ Marks Success")
                    completion(.success(marks))
                }
                else if response.statusCode == 429 {
                    print("❌ Marks Failure")
                    completion(.failure(.tooManyRequests(message: "Try again later")))
                }
            }
            else {
                print("❌ Marks Failure")
                completion(.failure(.noResponse(message: "Did not get a response")))
            }
        }
        task.resume()
    }
    
    func getDAs(cache: Bool = true, completion: @escaping(Result<[AssignmentDetail], APIError>)->Void) {
        print("⤵️ Getting DAs")
        guard let url = DAURL else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        let session = URLSession.shared
        if let cachedData = dataCache.cachedResponse(for: request) {
            if cache == true {
                let assignment = try! JSONDecoder().decode(Assignment.self, from: cachedData.data)
                print("✅ DA Success")
                completion(.success(assignment.assignmentDetail))
            }
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let assignment = try! JSONDecoder().decode(Assignment.self, from: data)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    dataCache.storeCachedResponse(cachedData, for: request)
                    print("✅ DA Success")
                    completion(.success(assignment.assignmentDetail))
                }
                else if response.statusCode == 429 {
                    print("❌ DA Failure")
                    completion(.failure(.tooManyRequests(message: "Try again later")))
                }
            }
            else {
                print("❌ DA Failure")
                completion(.failure(.noResponse(message: "Did not get a response")))
            }
        }
        task.resume()
    }
    
    func getGrades(cache: Bool = true, completion: @escaping(Result<Grades, APIError>)->Void) {
        print("⤵️ Getting Grades")
        guard let url = gradesURL else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        let session = URLSession.shared
        if let cachedData = dataCache.cachedResponse(for: request) {
            if cache == true {
                let grades = try! JSONDecoder().decode(Grades.self, from: cachedData.data)
                print("✅ Grades Success")
                completion(.success(grades))
            }
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let grades = try! JSONDecoder().decode(Grades.self, from: data)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    dataCache.storeCachedResponse(cachedData, for: request)
                    print("✅ Grades Success")
                    completion(.success(grades))
                }
                else if response.statusCode == 429 {
                    print("❌ Grades Failure")
                    completion(.failure(.tooManyRequests(message: "Try again later")))
                }
            }
            else {
                print("❌ Grades Failure")
                completion(.failure(.noResponse(message: "Did not get a response")))
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
