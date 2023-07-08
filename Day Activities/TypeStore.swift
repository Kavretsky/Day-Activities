//
//  ActivityTypeStore.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 03.07.2023.
//

import Foundation
import SwiftUI

struct ActivityType: Identifiable {
    let id: UUID = UUID()
    var emoji: String
    var isActive: Bool = true
    var backgroundRGBA: RGBAColor
    var description: String
    
    fileprivate init(id: UUID = UUID(), emoji: String, backgroundRGBA: RGBAColor, description: String) {
        self.emoji = emoji
        self.backgroundRGBA = backgroundRGBA
        self.description = description
    }
}

class TypeStore: ObservableObject {
    @Published private var types = [ActivityType]()
    
    init() {
        addDefaultTypes()
        print("init")
    }
    
    deinit {
        print("deinit")
    }
    
    private func addDefaultTypes() {
        addType(emoji: "👍", background: Color(rgbaColor: RGBAColor(red: 182/255, green: 255/255, blue: 137/255, alpha: 1)), description: "Positive activity")
        addType(emoji: "😡", background: Color(rgbaColor: RGBAColor(red: 255/255, green: 194/255, blue: 137/255, alpha: 1)), description: "Negative activity")
        addType(emoji: "😇", background: Color(rgbaColor: RGBAColor(red: 115/255, green: 14/255, blue: 137/255, alpha: 1)), description: "Rest activity")
        addType(emoji: "🥰", background: Color(rgbaColor: RGBAColor(red: 15/255, green: 140/255, blue: 17/255, alpha: 1)), description: "Rest activity")
    }
    
    var activeTypes: [ActivityType] {
        types.filter { $0.isActive }
    }
    
    func type(withID id: UUID) -> ActivityType? {
        types.first(where: { $0.id == id })
    }
    
    func addType(emoji: String, background: Color, description: String) {
        guard !emoji.isEmpty,
              emoji.first!.isEmoji,
              !description.isEmpty
        else { return }
        
        let background = RGBAColor(color: background)
        let shortLabel = String("\(emoji.first!)")
        types.append(ActivityType(emoji: shortLabel, backgroundRGBA: background, description: description))
    }
    
    func removeType(_ type: ActivityType) {
        if let index = types.firstIndex(where: {$0.id == type.id}) {
            types[index].isActive = false
        }
    }
}
