//
//  NewActivityView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI

struct NewActivityView: View {
    @EnvironmentObject var store: ActivityStore
    @State var activityName: String = ""
    @State var activityType: ActivityType = .positive
    @FocusState var focusOnNameTextField: Bool
    
    private var activityNameValidation: Bool {
        !activityName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Divider()
            HStack {
                newActivityForm
                newActivityButton
            }
            .padding(.vertical, 10)
        }
        .gesture(dismissKeyboardGesture())
    }
    
    var newActivityForm: some View {
        HStack(spacing: 0) {
            changeActivityTypeButton
            activityNameTextField
        }
        .background(.white)
        .clipShape(Capsule())
        .padding(.leading, 15)
    }
    
    @ViewBuilder
    private var activityNameTextField: some View {
        ZStack(alignment: .leading) {
            switch activityType {
            case .positive:
                Text("\(activityType.description) activity...")
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .font(.body)
                    .opacity(activityName.isEmpty ? 1 : 0)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                    
            case .negative:
                Text("\(activityType.description) activity...")
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .font(.body)
                    .opacity(activityName.isEmpty ? 1 : 0)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
            }
            TextField("", text: $activityName)
                .focused($focusOnNameTextField)
        }
        .padding(.leading, 8)
        .padding(.trailing, 10)
    }
    
    private var changeActivityTypeButton: some View {
        Button {
            withAnimation(.easeInOut) {
                changeActivityType()
            }
        } label: {
            switch activityType {
            case .positive:
                Text(activityType.label)
                    .font(.title2)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
            case .negative:
                Text(activityType.label)
                    .font(.title2)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                    
            }
                
        }
        .padding(.leading, 3)
        .frame(width: 42, height: 38)
        .background(activityType.color)
    }
    
    private func changeActivityType() {
        switch activityType {
        case .positive:
            activityType = .negative
        case .negative:
            activityType = .positive
        }
    }
    
    private var newActivityButton: some View {
        Button {
            withAnimation {
                store.addActivity(name: activityName.trimmingCharacters(in: .whitespaces), type: activityType)
                activityName = ""
            }
        } label: {
            Label("", systemImage: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
        }
        .disabled(!activityNameValidation)
    }
    
    private func dismissKeyboardGesture() -> some Gesture {
        DragGesture()
            .onChanged { _ in
                focusOnNameTextField = false
            }
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityView()
            .previewLayout(.sizeThatFits)
    }
}
