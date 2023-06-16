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
                NewActivityView()
                    .focused($focus)
            }
        }
    }
    
    private var background: some View {
        Color(uiColor: .systemGray6)
            .ignoresSafeArea(.all)
    }
    
    @State private var selectedActivityID: UUID?
    
    private var activityList2: some View {
        List(store.activities(for: .now), selection: $selectedActivityID) { activity in
            CardView(activity: activity)
                
        }
        .onChange(of: selectedActivityID) { newValue in
            if newValue != nil {
                data = store.activities(for: date).first(where: {$0.id == newValue})?.data ?? .init()
                isPresentingEditView = true
            }
        }
    }
    
    private var activityList: some View {
        List(selection: $activityToChange) {
            Section {
                ForEach(store.activities(for: .now)) { activity in
                    CardView(activity: activity)
                        .background(.white)
                        .onTapGesture {
                            print("tap")
                            activityToChange = activity
                            data = activity.data
                            print(data)
                            isPresentingEditView = true
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
        .sheet(isPresented: $isPresentingEditView) {
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
        }
    }
    
    
    private var calcelToolbarItem: some ToolbarContent{
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                isPresentingEditView = false
                selectedActivityID = nil
                print("cancel")
            }
        }
    }
    
    @State var isPresentingEditView: Bool = false
    @State var data = Activity.Data()
    @State private var activityToChange: Activity?
    
    private func doneAction() {
        guard let activity = activityToChange else { return }
        isPresentingEditView = false
        store.updateActivity(activity, with: data)
        activityToChange = nil
        data = .init()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
