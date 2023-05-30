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
    @Published private var activities = [Activity]()
    
    init() {
        activities.append(Activity(id: 1, name: "Morning walking with dog afasf asnf asnf jknafs ", type: .negative, startDateTime: Date(timeIntervalSinceReferenceDate: 118800)))
        activities.append(Activity(id: 2, name: "Morning walking with dog ", type: .positive, startDateTime: .now))
    }
    
    //MARK: Intent
    func addActivity(name: String, type: ActivityType) {
        let uniqueId = (activities.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        if let index = activities.firstIndex(where: { $0.id == (uniqueId - 1) }) {
            activities[index].finishDateTime = .now
        }
        let activity = Activity(id: uniqueId, name: name, type: type, startDateTime: .now)
        activities.append(activity)
    }
    
    func activities(for specificDate: Date) -> [Activity] {
        activities.filter { $0.startDateTime.formatted(.dateTime.day().month().year()) == specificDate.formatted(.dateTime.day().month().year())
        }
    }
    
    var datesInHistory: Set<Date> {
        activities.reduce(into: Set<Date>.init()) { partialResult, activity in
            partialResult.insert(activity.startDateTime)
        }
    }
}
