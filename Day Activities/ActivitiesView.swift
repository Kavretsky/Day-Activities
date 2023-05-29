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
    
    var activityList: some View {
        List {
            ForEach(store.activities) { activity in
                CardView(activity: activity)
            }
        }
        .background(Color(uiColor: .quaternarySystemFill))
        .scrollContentBackground(.hidden)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
