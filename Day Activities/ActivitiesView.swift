//
//  ActivitiesView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 21.05.2023.
//

import SwiftUI

struct ActivitiesView: View {
    @EnvironmentObject var store: ActivityStore
    private var date: Date = .now
    @FocusState var focus: Bool
    
    let activitiesDate: Date = .now
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                activityList
                    .onTapGesture {
                        focus = false
                    }
                NewActivityView()
                    .focused($focus)
            }
        }
        
    }
    
    private var background: some View {
        Color(uiColor: .systemGray6)
            .ignoresSafeArea(.all)
    }
    
    @State private var showTint = true
    
    private var activityList: some View {
        List {
            Section {
                ForEach(store.activities(for: .now)) { activity in
                    CardView(activity: activity)
                        .onTapGesture {
                            activityToChange = activity
                            data = activity.data
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
            NavigationView {
                ActivityEditorView(data: $data)
                    .navigationTitle(Text("Edit Activity", comment: "Header of edit activity view"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        doneToolbarItem
                        calcelToolbarItem
                    }
            }
        }
    }
    
    private var doneToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                doneAction()
            } label: {
                Text("Done", comment: "Save activity changes button")
            }
            .disabled(!dataValidation)
        }
    }
    
    private var dataValidation: Bool {
        !data.name.isEmpty && data.startDateTime <= data.finishDateTime ?? .now
    }
    
    
    private var calcelToolbarItem: some ToolbarContent{
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                activityToChange = nil
            }
        }
    }
    

    @State var data = Activity.Data()
    @State private var activityToChange: Activity?
    
    private func doneAction() {
        guard let activity = activityToChange else { return }
        store.updateActivity(activity, with: data)
        activityToChange = nil
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
