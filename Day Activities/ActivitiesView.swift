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
        VStack {
            activityList
                .overlay(alignment: .bottom) {
                    CreateActivityView()
                        .focused($focus)
                }
            
        }
        .onTapGesture {
            focus = false
        }
    }
    
    var activityList: some View {
        List {
            ForEach(store.activities) { activity in
                CardView(activity: activity)
            }
        }
        .scrollDismissesKeyboard(.automatic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
