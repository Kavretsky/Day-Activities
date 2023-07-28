//
//  Day_ActivitiesApp.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 21.05.2023.
//

import SwiftUI

@main
struct Day_ActivitiesApp: App {
    @StateObject var activityStore = ActivityStore()
    @StateObject var activityTypeStore = TypeStore()
    
    var body: some Scene {
        WindowGroup {
            ActivitiesView()
//            TestView()
                .environmentObject(activityStore)
                .environmentObject(activityTypeStore)
        }
    }
}
