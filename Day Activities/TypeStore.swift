//
//  ActivityTypeStore.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 03.07.2023.
//

import Foundation
import SwiftUI

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
    
    var typesToDelete: [ActivityType] {
        types.filter { !$0.isActive }
    }
    
    func type(withID id: String) -> ActivityType {
        types.first(where: { $0.id == id }) ?? types.first(where: { $0.isActive })!
    }
    
    func restore(_ type: ActivityType) {
        if let index = types.firstIndex(of: type) {
            types[index].isActive = true
        }
    }
    
    func addType(emoji: String, background: Color, description: String) {
        guard !emoji.isEmpty,
              emoji.first!.isEmoji
        else { return }
        
        let background = RGBAColor(color: background)
        let shortLabel = String("\(emoji.first!)")
        types.append(ActivityType(emoji: shortLabel, backgroundRGBA: background, description: description))
    }
    
    @discardableResult
    func addType(with data: ActivityType.Data) -> ActivityType? {
        guard !data.emoji.isEmpty, data.emoji.first!.isEmoji else { return nil }
        
        types.append(ActivityType(data: data))
        return activeTypes.last
    }
    
    func removeType(_ type: ActivityType) {
        guard activeTypes.count > 2 else { return }
        if let index = types.firstIndex(where: {$0.id == type.id}) {
            types[index].isActive = false
        }
    }
    
    func updateType(_ type: ActivityType, with data: ActivityType.Data) {
        guard !data.emoji.isEmpty else { return }
        types[type].update(from: data)
    }
}
