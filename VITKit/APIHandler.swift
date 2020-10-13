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
    
    func getDAs(cache: Bool = true, completion: @escaping(Result<[Assignment], APIError>)->Void) {
        print("⤵️ Getting DAs")
        guard let url = DAURL else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .greatestFiniteMagnitude)
        let session = URLSession.shared
        if let cachedData = dataCache.cachedResponse(for: request) {
            if cache == true {
                let assignment = try! JSONDecoder().decode(DA.self, from: cachedData.data)
                print("✅ DA Success")
                completion(.success(assignment.assignments))
            }
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    let assignment = try! JSONDecoder().decode(DA.self, from: data)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    dataCache.storeCachedResponse(cachedData, for: request)
                    print("✅ DA Success")
                    completion(.success(assignment.assignments))
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
    
    func getUpcomingClasses( completion: @escaping(Result<[UpcomingClass], APIError>) -> Void) {
        print("⤵️ Getting Upcoming")
        guard let url = upcomingURL else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    if let classes = try? JSONDecoder().decode([UpcomingClass].self, from: data) {
                        print("✅ Upcoming Success")
                        completion(.success(classes))
                    }
                    else {
                        print("❌ Timetable Failure")
                        completion(.failure(.decodingError(message: "Couldn't get upcoming")))
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
    
    
    func saveLoginState() {
        if let userDefaults = UserDefaults(suiteName: "group.uni") {
            userDefaults.set(VIT.loggedIn, forKey: "login")
            userDefaults.set(regNum, forKey: "regno")
            userDefaults.synchronize()
        }
    }
    
    func fetchLoginState() -> Bool{
        if let userDefaults = UserDefaults(suiteName: "group.uni") {
            VIT.loggedIn = userDefaults.bool(forKey: "login")
            regNum = userDefaults.string(forKey: "regno") ?? ""
            userDefaults.synchronize()
            return VIT.loggedIn
        }
        return false
    }
}
