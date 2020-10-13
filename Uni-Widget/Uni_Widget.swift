//
//  Uni_Widget.swift
//  Uni-Widget
//
//  Created by Aritro Paul on 22/09/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> TimetableEntry {
        TimetableEntry(date: Date(), subject: SubjectEntry(className: "CSE1001", attendance: "76", date: "10:00 AM".timeToDate() ?? Date()), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimetableEntry) -> ()) {
        let entry = TimetableEntry(date: Date(), subject: SubjectEntry(className: "CSE1001", attendance: "76", date: "10:00 AM".timeToDate() ?? Date()), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<TimetableEntry>) -> ()) {

        var timeline: Timeline<TimetableEntry>!
        let components = DateComponents(minute: 30)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        
        if VIT.shared.fetchLoginState() == false {
            let entry = TimetableEntry(date: Date(), subject: SubjectEntry(className: "Not logged in", attendance: "", date: Date()), configuration: ConfigurationIntent())
            timeline = Timeline(entries: [entry], policy: .after(futureDate))
            completion(timeline)
        }
        
        VIT.shared.getUpcomingClasses { (result) in
            switch result {
            case .success(let classes) :
                if classes.count == 0 {
                    let entry = TimetableEntry(date: Date(), subject: SubjectEntry(className: "No classes for today" , attendance: "", date: Date()),  configuration: ConfigurationIntent())
                    timeline = Timeline(entries: [entry], policy: .after(futureDate))
                }
                else {
                    let subject = classes[0]
                    let entry = TimetableEntry(date: Date(), subject: SubjectEntry(className: subject.title , attendance: subject.attendance, date: subject.start.timeToDate() ?? Date()), configuration: ConfigurationIntent())
                    timeline = Timeline(entries: [entry], policy: .after(futureDate))
                }
                completion(timeline)
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}

struct TimetableEntry: TimelineEntry {
    let date: Date
    let subject: SubjectEntry
    let configuration: ConfigurationIntent
}

struct SubjectEntry {
    let className: String
    let attendance: String
    let date: Date
}

struct Uni_WidgetEntryView : View {
    var entry: TimetableEntry

    var body: some View {
        if entry.subject.className == "No classes for today" {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .padding()
                Text("Done with Classes for today")
                    .bold()
                    .foregroundColor(.primary)
                    .font(.footnote)
            }
            .padding()
        }
        else if entry.subject.className == "Not Logged in" {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "exclamationmark.fill")
                    .foregroundColor(.orange)
                    .padding()
                Text("Not Logged in")
                    .bold()
                    .foregroundColor(.primary)
                    .font(.footnote)
            }
            .padding()
        }
        else {
            VStack(alignment: .leading, spacing: 5) {
                Text("Upcoming Class")
                    .bold()
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.subject.className.abbr() + " • " + entry.subject.attendance + "%")
                        .foregroundColor(.secondary)
                        .bold()
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    Text((entry.subject.date.timeToString()))
                        .bold()
                        .font(.caption)
                }
                .padding(2)
            }
            .padding()
        }
    }
}

@main
struct Uni_Widget: Widget {
    let kind: String = "Uni_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Uni_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Uni!")
        .description("This is a timetable widget.")
    }
}
