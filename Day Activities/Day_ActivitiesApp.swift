//
//  Day_ActivitiesApp.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 21.05.2023.
//

import SwiftUI

@main
struct Day_ActivitiesApp: App {
    @StateObject var store = ActivityStore()
    var body: some Scene {
        WindowGroup {
//            CreateActivityView(newActivityButtonAction: {})
            ActivitiesView()
                .environmentObject(store)
        }
    }
}
