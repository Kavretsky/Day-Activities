//
//  ActivityStore.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI
import Foundation

struct Activity: Identifiable {
    let id: Int
    var name: String
    var type: ActivityType
    fileprivate(set) var startDateTime: Date
    fileprivate(set) var finishDateTime: Date?
    
    fileprivate init(id: Int, name: String, type: ActivityType, startDateTime: Date, finishDateTime: Date? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.startDateTime = startDateTime
        self.finishDateTime = finishDateTime
    }
}

enum ActivityType {
    case positive
    case negative
    
    var label: String {
        switch self {
        case .negative: return UserSettings.negativeActivityEmoji
        case .positive: return UserSettings.positiveActivityEmoji
        }
    }
    
    var color: Color {
        switch self {
        case .positive:
            return Color(rgbaColor: UserSettings.positiveActivityRGBAColor)
        case .negative:
            return Color(rgbaColor: UserSettings.negativeActivityRGBAColor)
        }
    }
    
    var description: String {
        switch self {
        case .positive:
            return "Positive"
        case .negative:
            return "Negative"
        }
    }
    
}

final class ActivityStore: ObservableObject {
    @Published var activities = [Activity]()
    
//    func activities(per date: Date) -> [Activity]? {
//        let day = Calendar.current.dateComponents([.day, .month, .year], from: date)
//        return activities.filter { Calendar.current.dateComponents(in: .current, from: $0.startDateTime).isSameDay(as: day) }
//    }
    
//    var datesInHistory: [Date] {
//        activities.reduce(into: Set<Date>) { partialResult, activity in
//            partialResult.insert(activity.startDateTime)
//        }
//
//
//    }
    init() {
        activities.append(Activity(id: 1, name: "Morning walking with dog afasf asnf asnf jknafs ", type: .negative, startDateTime: .now))
        activities.append(Activity(id: 2, name: "Morning walking with dog afasf asnf asnf jknafs ", type: .positive, startDateTime: .now))
    }
    
    //MARK: Intent
    func addActivity(name: String, type: ActivityType) {
        let uniqueId = (activities.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        let activity = Activity(id: uniqueId, name: name, type: type, startDateTime: Date())
        activities.append(activity)
    }
    
    
}


//extension DateFormatter {
//    static var shortDate: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US")
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        return formatter
//    }()
//}

extension DateComponents {
    func isSameDay(as other: DateComponents) -> Bool {
        return self.year == other.year && self.month == other.month && self.day == other.day
    }
}
