//
//  Notifications.swift
//  VIT
//
//  Created by Aritro Paul on 23/08/20.
//

import Foundation
import UserNotifications

func scheduleClassNotification(course: String, time: Date) {
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "Knock knock"
    content.body = "Your \(course) class starts in 15 mins!"
    content.categoryIdentifier = "alarm"
    content.sound = UNNotificationSound.default

    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.weekday, .hour, .minute], from: time.removing(minutes: 15)!)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    let request = UNNotificationRequest(identifier: course, content: content, trigger: trigger)
    center.add(request)
}

func scheduleDANotification(assignment: String, course: String, time: Date) {
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "Work time!"
    content.body = "Your \(course) \(assignment) is due tomorrow"
    content.categoryIdentifier = "reminder"
    content.sound = UNNotificationSound.default

    
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.day], from: time.removing(days: 1)!)
    dateComponents.hour = 0
    dateComponents.minute = 0
    print(dateComponents)
    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    var request = UNNotificationRequest(identifier: course, content: content, trigger: trigger)
    center.add(request)
    
    content.body = "Your \(course) \(assignment) is due today"
    dateComponents = calendar.dateComponents([.day, .hour, .minute], from: time.removing(hours: 6)!)
    print(dateComponents) 
    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    request = UNNotificationRequest(identifier: course, content: content, trigger: trigger)
    center.add(request)
}


extension Date {
    func removing(minutes: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .minute, value: -(minutes), to: self)
        return result
    }
    
    func removing(hours: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .hour, value: -(hours), to: self)
        return result
    }
    
    func removing(days: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .day, value: -(days), to: self)
        return result
    }
    
    func toString(withFormat format: String = "dd MMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
    
}

extension String {
    func toDate(withFormat format: String = "dd-MMM-yyyy")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func date()-> String?{
        self.toDate()?.toString()
    }
}
