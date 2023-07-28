//
//  NewActivityView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI

struct NewActivityView: View {
    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var typeStore: TypeStore
    @State var name: String = ""
    @FocusState var focusOnNameTextField
    
    @SceneStorage("NewActivityView.chosenTypeIndex")
    private var chosenTypeIndex = 0
    
    private var chosenType: ActivityType {
        typeStore.activeTypes[chosenTypeIndex]
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
            typeChooser(for: chosenType)
            activityNameTextField(for: chosenType)
        }
        .background(Color(uiColor: .systemBackground), in: Capsule())
        .clipped()
    }
    
    private func activityNameTextField(for type: ActivityType) -> some View {
        ZStack(alignment: .leading) {
            Text("\(type.description)...")
                .foregroundColor(Color(uiColor: .systemGray2))
                .font(.body)
                .opacity(name.isEmpty ? 1 : 0)
                .transition(rollTransition)
                .id(type.id)
            TextField("", text: $name)
                .focused($focusOnNameTextField)
        }
        .padding(.leading, 8)
        .padding(.trailing, 10)
    }
    
    private func typeChooser(for type: ActivityType) -> some View {
        ZStack {
            Color(rgbaColor: type.backgroundRGBA)
            Text(type.emoji)
                .font(.title2)
                .transition(rollTransition)
                .id(type.id)
                .zIndex(1)
        }
        .frame(width: 45, height: 38)
        .clipShape(Capsule())
        .contentShape(.contextMenuPreview, Capsule())
        .gesture(tapSimultaneouslyWithLongPress())
        .contextMenu { contextMenu }
        .sheet(isPresented: $isManagingTypes) {
            TypeManagerView()
        }
    }
    
    @State var longPressStartDate: Date?
    
    private func tapSimultaneouslyWithLongPress() -> some Gesture {
        let tap = TapGesture()
            .onEnded {
                let longPressDuration = longPressStartDate?.distance(to: .now) ?? 0
                if longPressStartDate != nil && longPressDuration > 0.16 {
                    print("onEnded tap. distance: \(longPressDuration)")
                    if longPressDuration < 0.4 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + longPressDuration * 1.7) {
                            withAnimation {
                                chosenTypeIndex = (chosenTypeIndex + 1) % typeStore.activeTypes.count
                                longPressStartDate = nil
                            }
                        }
                    }
                    
                } else {
                    withAnimation {
                        chosenTypeIndex = (chosenTypeIndex + 1) % typeStore.activeTypes.count
                        longPressStartDate = nil
                    }
                }
            }
        
        let longPress = LongPressGesture(minimumDuration: 0.42)
            .onChanged { _ in
                    longPressStartDate = .now
            }

        return tap.simultaneously(with: longPress)
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Button {
            isManagingTypes = true
        } label: {
            Label("Manage", systemImage: "slider.vertical.3")
        }
        Divider()
        ForEach(typeStore.activeTypes) { type in
            let index = typeStore.activeTypes.index(matching: type)
            Button {
                if let index = typeStore.activeTypes.index(matching: type) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            chosenTypeIndex = index
                        }
                        
                    }
                }
            } label: {
                if chosenTypeIndex == index {
                    Label(type.emoji, systemImage: "checkmark")
                } else {
                    Text(type.emoji)
                }
                
            }
        }
        

    }
    
    @State private var isManagingTypes = false
    
    private var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity))
    }
    
    private var newActivityButton: some View {
        Button {
            withAnimation {
                activityStore.addActivity(name: name.trimmingCharacters(in: .whitespaces), typeID: chosenType.id)
                name = ""
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
    
    private var activityNameValidation: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityView()
//            .previewLayout(.sizeThatFits)
            .environmentObject(TypeStore())
    }
}
