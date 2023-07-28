//
//  TypeManagerView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 19.07.2023.
//

import SwiftUI

struct TypeManagerView: View {
    @EnvironmentObject var store: TypeStore
    @State private var path: [ActivityType] = []
    
    var body: some View {
        navigationStack
    }
    
    private var navigationStack: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(store.activeTypes){ type in
                    typeNavigationLink(type)
                }
                newTypeButton
            }
            .navigationDestination(for: ActivityType.self) { type in
                if store.activeTypes.count > 2 {
                    TypeEditorView(typeToEdit: type) { type, data in
                        store.updateType(type, with: data)
                    } deleteAction: { type in
                        store.removeType(type)
                        path.remove(type)
                    }
                } else {
                    TypeEditorView(typeToEdit: type) { type, data in
                        store.updateType(type, with: data)
                    }
                }
            }
            .navigationTitle("Type manager")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func typeNavigationLink(_ type: ActivityType) -> some View {
        NavigationLink(value: type) {
            Label {
                Text(type.description)
            } icon: {
                emojiInCapsule(for: type)
            }
        }
    }
    
    private var newTypeButton: some View {
        Button("New type") {
            withAnimation {
                store.addType(with: ActivityType.sampleData())
                path.append(store.activeTypes.last!)
            }
        }
        .bold()
        .padding(.vertical, 7)
    }
    
    private func emojiInCapsule(for type: ActivityType) -> some View {
        ZStack {
            Color(rgbaColor: type.backgroundRGBA)
            Text(type.emoji)
                .font(.title2)
        }
        .frame(width: 40, height: 37)
        .clipShape(Capsule())
    }
}

struct TypeManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TypeManagerView()
            .environmentObject(TypeStore())
    }
}
