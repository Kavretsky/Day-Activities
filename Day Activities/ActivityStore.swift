//
//  ActivityStore.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI
import Foundation

final class ActivityStore: ObservableObject {
    @Published private var activities = [Activity]()
    
    var datesInHistory: Set<Date> {
        activities.reduce(into: Set<Date>.init()) { partialResult, activity in
            partialResult.insert(activity.startDateTime)
        }
    }
    
    init() {
        addActivity(name: "Morning walking with dog", type: .positive)
        addActivity(name: "Working on new project", type: .negative)
    }
    
    //MARK: Intents
    func addActivity(name: String, type: ActivityType) {
        if let index = activities.firstIndex(where: { $0.finishDateTime == nil }) {
            activities[index].finishDateTime = .now
        }
        let activity = Activity(name: name, type: type, startDateTime: .now)
        activities.append(activity)
    }
    
    func activities(for specificDate: Date) -> [Activity] {
        activities.filter { $0.startDateTime.isSameDay(with: specificDate) }
    }
    
    func updateActivity(_ activityToUpdate: Activity, with data: Activity.Data) {
        guard let index = activities.firstIndex(where: {$0.id == activityToUpdate.id}) else { return }
        guard data.startDateTime <= data.finishDateTime ?? data.startDateTime
                && data.startDateTime.isSameDay(with: data.finishDateTime ?? data.startDateTime)
                && !data.name.isEmpty else { return }
        activities[index].update(from: data)
    }
    
    
}
