//
//  Notifications.swift
//  VIT
//
//  Created by Aritro Paul on 23/08/20.
//

import Foundation
import UserNotifications

func scheduleNotification(course: String, time: Date) {
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


extension Date {
    func removing(minutes: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .minute, value: -(minutes), to: self)
        return result
    }
}
