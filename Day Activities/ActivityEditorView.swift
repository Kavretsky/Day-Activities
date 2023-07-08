//
//  ActivityEditorView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 31.05.2023.
//

import SwiftUI

struct ActivityEditorView: View {
    @Binding var activityToChange: Activity?
    @State private var data: Activity.Data = .init()
    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var typeStore: TypeStore
    
    
    init(activityToChange: Binding<Activity?>) {
        _activityToChange = activityToChange
    }
    @FocusState var focus: Bool
    
    @Namespace private var typeNamespaceID
    
    
    var body: some View {
        NavigationView {
            editForm
                .navigationTitle(Text("Edit Activity", comment: "Header of edit activity view"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    doneToolbarItem
                    calcelToolbarItem
                    deleteToolbarItem
                }
        }
        .confirmationDialog("Delete activity", isPresented: $isShowingDeleteDialog) {
            Button("Delete", role: .destructive) {
                deleteActivity(activityToChange)
                activityToChange = nil
            }
        } message: {
            Text("Are you sure to delete this activity?")
        }
        .onAppear {
            data = activityToChange?.data ?? .init()
        }
    }
    
    //MARK: FORM
    private var editForm: some View {
        Form {
            descriptionSection
            timingSection
                .onTapGesture {
                    focus = false
                }
        }
        .scrollDismissesKeyboard(.immediately)
        .edgesIgnoringSafeArea(.bottom)
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
        .focused($focus)
    }
    
    private var typeSelection: some View {
        HStack(spacing: 3) {
            ForEach(typeStore.activeTypes) { type in
                typeView(type)
                    .zIndex(type.id == data.typeID ? 0 : 1)
                    .onTapGesture {
                        withAnimation {
                            data.typeID = type.id
                        }
                    }
                    .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.9, blendDuration: 1), value: data.typeID)
            }
        }
    }
    
    private func typeView(_ type: ActivityType) -> some View {
        Text(type.emoji)
            .font(.headline)
            .padding(7)
            .background {
                if type.id == data.typeID {
                    Capsule()
                        .fill(Color(rgbaColor: type.backgroundRGBA))
                        .offset(x: 0)
                        .matchedGeometryEffect(id: "typeBackgroundID", in: typeNamespaceID)
                }
            }
    }
    
    @State var finishTime: Date = .now
    
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
            Button("Finish now") { }
                .onTapGesture {
                    focus = false
                    finishTime = .now
                    data.finishDateTime = finishTime
                }
        }
        
    }
    
    //MARK: Toolbar
    private var doneToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                doneAction()
            } label: {
                Text("Done", comment: "Save activity changes button")
            }
            .disabled(!isDataValid)
        }
    }
    
    private var isDataValid: Bool {
        !data.name.isEmpty && data.startDateTime <= data.finishDateTime ?? .now
    }
    
    private func doneAction() {
        guard let activity = activityToChange else { return }
        activityStore.updateActivity(activity, with: data)
        activityToChange = nil
        
    }
    
    private var calcelToolbarItem: some ToolbarContent{
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                activityToChange = nil
            }
        }
    }
    
    @State private var isShowingDeleteDialog = false
    
    private var deleteToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button {
                isShowingDeleteDialog = true
            } label: {
                Text("Delete Activity")
                    .foregroundColor(.red)
            }
        }
    }
    
    private func deleteActivity(_ activity: Activity?) {
        guard let activity = activity else { return }
        activityStore.deleteActivity(activity)
        activityToChange = nil
    }
}

struct ActivityEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = ActivityStore()
        ActivityEditorView(activityToChange: .constant(store.activities(for: .now).last!))
            .environmentObject(store)
            .environmentObject(TypeStore())
    }
}
