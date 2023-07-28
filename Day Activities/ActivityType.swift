//
//  ActivityType.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 25.07.2023.
//

import Foundation

struct ActivityType: Identifiable, Hashable {
    let id: UUID = UUID()
    var emoji: String
    var isActive: Bool = true
    var backgroundRGBA: RGBAColor
    var description: String
    
    init(emoji: String, backgroundRGBA: RGBAColor, description: String) {
        self.emoji = emoji
        self.backgroundRGBA = backgroundRGBA
        self.description = description
    }
}

extension ActivityType {
    struct Data: Hashable {
        var emoji = ""
        var backgroundRGBA = RGBAColor(color: .black)
        var description = ""
    }
    
    var data: Data {
        Data(emoji: emoji, backgroundRGBA: backgroundRGBA, description: description)
    }
    
    mutating func update(from data: Data) {
        emoji = data.emoji
        backgroundRGBA = data.backgroundRGBA
        description = data.description
    }
    
    init(data: Data) {
        emoji = data.emoji
        backgroundRGBA = data.backgroundRGBA
        description = data.description
    }
    
    private static func randomEmoji() -> String {
        let emojiRange = 0x1F600...0x1F64F 
        let randomScalar = UnicodeScalar(Int.random(in: emojiRange))!
        return String(randomScalar)
    }
    
    private static func randomBackgroundRGBA() -> RGBAColor {
        return RGBAColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
    
    static func sampleData() -> Data {
        Data(emoji: randomEmoji(), backgroundRGBA: randomBackgroundRGBA(), description: "New type")
    }
}
