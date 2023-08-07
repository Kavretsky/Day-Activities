//
//  ActivitiesView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 21.05.2023.
//

import SwiftUI

struct ActivitiesView: View {
    
    @EnvironmentObject var store: ActivityStore
    @EnvironmentObject var typeStore: TypeStore
    private var date: Date = .now
    @State var focus: Bool = false
    @State private var activityToChange: Activity?
    
    private var activities: [Activity] {
        return store.activities(for: date)
    }
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                activityList
                    .onTapGesture {
                        hideKeyboard()
                    }
                NewActivityView()
                    
            }
        }
    }
    
    private var background: some View {
        Color(uiColor: .systemGray6)
            .ignoresSafeArea(.all)
    }
    
    private var activityList: some View {
        List {
            if !activities.isEmpty {
                DayActivityChart(data: activities)
                    .padding(.vertical, 8)
            }
            Section {
                ForEach(activities) { activity in
                    CardView(activity: activity)
                        .onTapGesture {
                            activityToChange = activity
                        }
                }
            } header: {
                Text("Activities", comment: "Activities list headline")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .background(Color(uiColor: .quaternarySystemFill))
        .scrollContentBackground(.hidden)
        .sheet(item: $activityToChange) { _ in
            ActivityEditorView(activityToChange: $activityToChange)
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
            .environmentObject(TypeStore())
    }
}
