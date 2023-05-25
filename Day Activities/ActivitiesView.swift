//
//  ActivitiesView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 21.05.2023.
//

import SwiftUI

struct ActivitiesView: View {
    @EnvironmentObject var store: ActivityStore
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                activityList
                NewActivityView()
                    .focused($focus)
            }
            .onTapGesture {
                focus = false
            }
        }
    }
    
    private var background: some View {
        Color(uiColor: .secondarySystemBackground)
            .ignoresSafeArea(.all)
    }
    
    var activityList: some View {
        List {
            ForEach(store.activities) { activity in
                CardView(activity: activity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
