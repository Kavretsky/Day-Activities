//
//  ActivityEditorView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 31.05.2023.
//

import SwiftUI

struct ActivityEditorView: View {
    @Binding var data: Activity.Data
    @State var finishTime: Date = .now
    
    @Namespace private var typeNamespaceID
    
    
    var body: some View {
        Form {
            descriptionSection
            timingSection
        }
    }
    
    private var descriptionSection: some View {
        Section {
            descriptionTextField
            typeSelection
        }
    }
    
    private var descriptionTextField: some View {
        TextField("Description",
                  text: $data.name,
                  prompt: Text("Activity..."),
                  axis: .vertical)
    }
    
    private var typeSelection: some View {
        HStack(spacing: 3) {
            ForEach(ActivityType.allCases, id: \.self) { type in
                Text(type.label)
                    .font(.headline)
                    .padding(7)
                    .background {
                        if type == data.type {
                            Capsule()
                                .fill(type.color)
                                .offset(x: 0)
                                .matchedGeometryEffect(id: "typeBackgroundID", in: typeNamespaceID)
                        }
                    }
                    .zIndex(type == data.type ? 0 : 1)
                    .onTapGesture {
                        withAnimation {
                            data.type = type
                        }
                    }
                    .animation(Animation.interactiveSpring(), value: data.type)
            }
        }
    }
    
    @ViewBuilder
    private var timingSection: some View {
        Section {
            startTimeRow
            finishTimeRow
        }
    }
    
    private var startTimeRow: some View {
        DatePicker("Started at", selection: $data.startDateTime, displayedComponents: .hourAndMinute)
    }
    
    @ViewBuilder
    private var finishTimeRow: some View {
        if data.finishDateTime != nil {
            DatePicker("Finished at", selection: $finishTime, displayedComponents: .hourAndMinute)
                .onChange(of: finishTime) { newValue in
                    data.finishDateTime = finishTime
                }
        } else {
            Button("Finish now") {
                finishTime = .now
                data.finishDateTime = finishTime
            }
        }
    }
}

struct ActivityEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditorView(data: .constant(ActivityStore().activities(for: .now).first!.data))
    }
}
