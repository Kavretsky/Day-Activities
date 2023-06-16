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
    
    
    var body: some View {
        Form {
            descriptionSection
            startedAtSection
            finishedAtSection
        }
    }
    
    private var descriptionSection: some View {
        Section {
            TextField("Description", text: $data.name, axis: .vertical)
            Picker("Type", selection: $data.type) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    Text(type.label)
                }
            }
            .pickerStyle(.wheel)
        }
    }
    
    private var typeSection: some View {
        Section {
            Picker("Type", selection: $data.type) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    Text(type.label)
                }
            }
        }
    }
    
    private var startedAtSection: some View {
        Section {
            DatePicker("Started at", selection: $data.startDateTime, displayedComponents: .hourAndMinute)
        }
    }
    
    @ViewBuilder
    private var finishedAtSection: some View {
        if data.finishDateTime != nil {
            Section {
                DatePicker("Finished at", selection: $finishTime, displayedComponents: .hourAndMinute)
            }
            .onChange(of: finishTime) { newValue in
                data.finishDateTime = finishTime
            }
        } else {
            Button("Finish") {
                data.finishDateTime = .now
            }
        }
    }
}

struct ActivityEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditorView(data: .constant(ActivityStore().activities(for: .now).first!.data))
    }
}
