//
//  CardView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI

struct CardView: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(activity.name)
                .font(.body)
            HStack {
                Text(activity.startDateTime.formatted(.dateTime.hour().minute()))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(activity.type.label)
                    .font(.subheadline)
            }
        }
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .environmentObject(ActivityStore())
    }
}
