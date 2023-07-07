//
//  ActivityTypeStore.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 03.07.2023.
//

import Foundation
import SwiftUI

struct ActivityTypeStruct: Identifiable {
    let id: UUID = UUID()
    var label: String
    var isActive: Bool = true
    var backgroundRGBA: RGBAColor
    var description: String
    
    fileprivate init(id: UUID = UUID(), label: String, backgroundRGBA: RGBAColor, description: String) {
        self.label = label
        self.backgroundRGBA = backgroundRGBA
        self.description = description
    }
}

class ActivityTypeStore: ObservableObject {
    @Published private var types = [ActivityTypeStruct]()
    
    init() {
        addDefaultTypes()
        print("init")
    }
    
    deinit {
        print("deinit")
    }
    
    private func addDefaultTypes() {
        addType(label: "👍", background: Color(rgbaColor: RGBAColor(red: 182/255, green: 255/255, blue: 137/255, alpha: 1)), description: "Positive activity")
        addType(label: "😡", background: Color(rgbaColor: RGBAColor(red: 255/255, green: 194/255, blue: 137/255, alpha: 1)), description: "Negative activity")
        addType(label: "😇", background: Color(rgbaColor: RGBAColor(red: 115/255, green: 14/255, blue: 137/255, alpha: 1)), description: "Rest activity")
    }
    
    var activeTypes: [ActivityTypeStruct] {
        types.filter { $0.isActive }
    }
    
    func typeById(_ id: UUID) -> ActivityTypeStruct? {
        types.first(where: { $0.id == id })
    }
    
    func addType(label: String, background: Color, description: String) {
        guard !label.isEmpty && !description.isEmpty else { return }
        let background = RGBAColor(color: background)
        print(background)
        let shortLabel = String("\(label.first!)")
        types.append(ActivityTypeStruct(label: shortLabel, backgroundRGBA: background, description: description))
    }
    
    func removeType(_ type: ActivityTypeStruct) {
        if let index = types.firstIndex(where: {$0.id == type.id}) {
            types[index].isActive = false
        }
    }
}
