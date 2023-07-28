//
//  TestView.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 26.07.2023.
//

import SwiftUI

struct TestView: View {
    @State private var emojis: String = "🤧🖖🪿"
    
    var body: some View {
        VStack {
            TextField("", text: $emojis)
                .textFieldStyle(.roundedBorder)
            Button("Check") {
                checkEmoji()
                let notAnEmojiCharacter: Character = "🪿"
                print(notAnEmojiCharacter.isEmoji)
            }
        }
        .padding()
    }
    
    private func checkEmoji() {
        for emoji in emojis {
            print(emoji.isEmoji)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
