//
//  NewActivityView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 22.05.2023.
//

import SwiftUI

struct NewActivityView: View {
    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var typeStore: ActivityTypeStore
    @State var activityName: String = ""
    @State var activityType: ActivityType = .positive
    @FocusState var focusOnNameTextField
//    @Binding var focus: Bool
    
    
    @SceneStorage("NewActivityView.chosenTypeIndex")
    private var chosenTypeIndex = 0
    
    private var chosenType: ActivityTypeStruct {
        typeStore.activeTypes[chosenTypeIndex]
    }
    
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
//            .onChange(of: focus) { newValue in
//                focusOnNameTextField = focus
//            }
//            .onChange(of: focusOnNameTextField) { newValue in
//                focus = focusOnNameTextField
//            }
    }
    
    private var newActivityForm: some View {
        HStack(spacing: 0) {
//            typeChooser(for: chosenType)
            typeChooser2(for: chosenType)
//                .id(125)

                
            activityNameTextField(for: chosenType)
//                .onTapGesture {
//                    focusOnNameTextField = true
//                }
        }
        .background(Color(uiColor: .systemBackground), in: Capsule())
    }
    
    private func activityNameTextField(for type: ActivityTypeStruct) -> some View {
        ZStack(alignment: .leading) {
            Text("\(type.description)...")
                .foregroundColor(Color(uiColor: .systemGray2))
                .font(.body)
                .opacity(activityName.isEmpty ? 1 : 0)
                .transition(rollTransition)
                .id(type.id)
            TextField("", text: $activityName)
                .focused($focusOnNameTextField)
        }
        .padding(.leading, 8)
        .padding(.trailing, 10)
    }
    
    private func typeChooser2(for type: ActivityTypeStruct) -> some View {
        ZStack {
            Color(rgbaColor: type.backgroundRGBA)
            Text(type.label)
                .font(.title2)
                .transition(rollTransition)
                .id(type.id)
//                .zIndex(1)
        }
      
        .frame(width: 45, height: 38)
        .clipShape(Capsule())
        .contentShape(.contextMenuPreview, Capsule())
        .gesture(tapSimultaneouslyWithLongPress())
        .contextMenu {
            
                
                contextMenu
            
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
//            .onEnded { _ in
//                focusOnNameTextField = false
//            }
        return tap.simultaneously(with: longPress)
    }
    
    private func typeChooser(for type: ActivityTypeStruct) -> some View {
        Button {
            withAnimation(.easeInOut) {
                chosenTypeIndex = (chosenTypeIndex + 1) % typeStore.activeTypes.count
            }
        } label: {
            Text(type.label)
                .font(.title2)
                .transition(rollTransition)
                .id(type.id)
        }
        .padding(.bottom, 1)
        .padding(.horizontal, 9)
        .frame(height: 38)
        .background(Color(rgbaColor: chosenType.backgroundRGBA))
        .clipShape(Capsule())
        .contentShape(.contextMenuPreview, Capsule())
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        ForEach(typeStore.activeTypes) { type in
            let index = typeStore.activeTypes.index(matching: type)
            Button {
                if let index = typeStore.activeTypes.index(matching: type) {
//                    focusOnNameTextField = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut) {
                            chosenTypeIndex = index
                        }
                        
                    }
                }
            } label: {
                if chosenTypeIndex == index {
                    Label(type.label, systemImage: "checkmark")
                } else {
                    Text(type.label)
                }
                
            }

            
        }
    }
    
    private var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity))
    }
    
    private var newActivityButton: some View {
        Button {
            withAnimation {
                activityStore.addActivity(name: activityName.trimmingCharacters(in: .whitespaces), type: activityType)
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
//            .previewLayout(.sizeThatFits)
            .environmentObject(ActivityTypeStore())
    }
}
