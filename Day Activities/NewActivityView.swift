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
                .ignoresSafeArea()
            HStack {
                newActivityForm
                newActivityButton
            }
            .padding(.vertical, 7)
            .padding(.leading, 12)
            .padding(.trailing, 10)
        }
    }
    
    private var newActivityForm: some View {
        HStack(spacing: 0) {
            changeActivityTypeButton
            activityNameTextField
                .onTapGesture {
                    focusOnNameTextField = true
                }
        }
        .background(Color(uiColor: .systemBackground), in: Capsule())
        .clipped()
    }
    
    @ViewBuilder
    private var activityNameTextField: some View {
        ZStack(alignment: .leading) {
            switch activityType {
            case .positive:
                Text("Positive activity", comment: "TextField prompt for positive activity")
                    .foregroundColor(Color(uiColor: .systemGray2))
                    .font(.body)
                    .opacity(activityName.isEmpty ? 1 : 0)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                    
            case .negative:
                Text("Negative activity", comment: "TextField prompt for negative activity")
                    .foregroundColor(Color(uiColor: .systemGray2))
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
        .padding(.bottom, 1)
        .frame(width: 45, height: 34)
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
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
        }
        .disabled(!activityNameValidation)
        .onTapGesture {
            if !activityNameValidation {
                focusOnNameTextField = true
            }
        }
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityView()
            .previewLayout(.sizeThatFits)
    }
}
