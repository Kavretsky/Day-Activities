//
//  TypeEditorView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 19.07.2023.
//

import SwiftUI

fileprivate enum FocusField: Hashable {
    case emojiTextField
    case descriptionTextField
}

struct TypeEditorView: View {
    @State private var typeToEdit: ActivityType
    private let saveAction: (ActivityType, ActivityType.Data) -> Void
    private let deleteAction: ((ActivityType) -> Void)?
    @State private var emoji: String
    @State private var description: String
    @FocusState private var focusedField: FocusField?
    
    init(typeToEdit: ActivityType, saveAction: @escaping (ActivityType, ActivityType.Data) -> Void, deleteAction: ((ActivityType) -> Void)? = nil) {
        _typeToEdit = State(initialValue: typeToEdit)
        self.saveAction = saveAction
        self.deleteAction = deleteAction
        _emoji = State(initialValue: typeToEdit.emoji)
        _typeBackgroundColor = State(initialValue: Color(rgbaColor: typeToEdit.backgroundRGBA))
        _description = State(initialValue: typeToEdit.description)
        
    }
    
    private var data: ActivityType.Data {
        ActivityType.Data(
            emoji: emoji,
            backgroundRGBA: RGBAColor(color: typeBackgroundColor),
            description: description
        )
    }
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 20) {
                emojiTextField
                    .padding()
                descriptionTextField
                typeBackgroundPicker
                Spacer()
            }
            .padding()
            .scrollDismissesKeyboard(.automatic)
        }
        .onChange(of: data) { _ in
            saveAction(typeToEdit, data)
        }
        .toolbar {
            if deleteAction != nil {
                deleteButton
            }
        }
        .confirmationDialog("Delete type", isPresented: $isShowingDeleteDialog) {
            Button("Delete", role: .destructive) {
                deleteAction!(typeToEdit)
            }
        } message: {
            Text("A you sure to delete type?")
        }
        
    }
    
    private var background: some View {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea(.all)
    }
    
    private var emojiTextField: some View {
        TextField("", text: $emoji)
            .frame(width: 50)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .padding()
            .background(typeBackgroundColor, in: Capsule())
            .focused($focusedField, equals: .emojiTextField)
            .onTapGesture {
                focusedField = .emojiTextField
            }
            .onChange(of: emoji) { newValue in
                let emojiString = newValue
                    .filter { $0.isEmoji && $0 != typeToEdit.emoji.first }
                guard !emojiString.isEmpty else {
                    emoji = typeToEdit.emoji
                    return
                }
                emoji = String(emojiString.first!)
                typeToEdit.emoji = emoji
            }
    }
    
    
    
    private var descriptionTextField: some View {
        TextField("Description", text: $description)
            .font(.title2).bold()
            .multilineTextAlignment(.center)
            .padding(.vertical, 16)
            .background(Color(uiColor: .secondarySystemGroupedBackground) ,in: RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                focusedField = .descriptionTextField
            }
            .focused($focusedField, equals: .descriptionTextField)
    }
    
    
    
    @State private var typeBackgroundColor: Color
    
    private var typeBackgroundPicker: some View {
        ColorPicker("Color", selection: $typeBackgroundColor)
            .bold()
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground) ,in: RoundedRectangle(cornerRadius: 10))
    }
    
    private var deleteButton: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button("Delete Type") {
                isShowingDeleteDialog = true
            }
            .buttonStyle(.automatic)
        .foregroundColor(.red)
        }
    }
    
    @State private var isShowingDeleteDialog = false
    
    
}

struct TypeEditorView_Previews: PreviewProvider {
    static let type = ActivityType(emoji: "🥰", backgroundRGBA: RGBAColor(red: 0.5, green: 0.3, blue: 0.7, alpha: 1), description: "Rest activity")
    static var previews: some View {
        TypeEditorView(typeToEdit: type) { _, _ in
            print("delete")
        }
    }
}
