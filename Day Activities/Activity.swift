//
//  Activity.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 06.06.2023.
//

import Foundation

struct Activity: Identifiable, Hashable {
    let id: UUID
    var name: String
    var type: ActivityType
    var startDateTime: Date
    var finishDateTime: Date?
    
    init(id: UUID = UUID(), name: String, type: ActivityType, startDateTime: Date, finishDateTime: Date? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.startDateTime = startDateTime
        self.finishDateTime = finishDateTime
    }
}

extension Activity {
    struct Data {
        var name = ""
        var type = ActivityType.positive
        var startDateTime = Date.now
        var finishDateTime: Date? = nil
    }
    
    var data: Data {
        Data(name: name, type: type, startDateTime: startDateTime, finishDateTime: finishDateTime)
    }
    
    mutating func update(from data: Data) {
        name = data.name
        type = data.type
        startDateTime = data.startDateTime
        finishDateTime = data.finishDateTime
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        type = data.type
        startDateTime = data.startDateTime
        finishDateTime = data.finishDateTime
    }
}
