//
//  CardView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var typesStore: TypeStore
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(activity.name)
                .font(.body)
            HStack {
                activityTimeInterval
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(typesStore.type(withID: activity.typeID).emoji)
                    .font(.subheadline)
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
    
    private var dateFormatStyle:  Date.FormatStyle {
        Date.FormatStyle().hour().minute()
    }
    
    @ViewBuilder
    private var activityTimeInterval: some View {
        if activity.finishDateTime != nil {
            Text("\(activity.startDateTime.formatted(dateFormatStyle)) — \(activity.finishDateTime!.formatted(dateFormatStyle))")
                .transition(.identity)
        } else {
            Text("Started at \(activity.startDateTime.formatted(dateFormatStyle))", comment: "Start time to current activity")
                .transition(.identity)
        }
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var store = ActivityStore()
    static var previews: some View {
        CardView(activity: store.activities(for: .now).first!)
            .environmentObject(ActivityStore())
            .environmentObject(TypeStore())
//            .scaledToFit()
    }
}
