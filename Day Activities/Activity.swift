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
    var typeID: UUID
    var startDateTime: Date
    var finishDateTime: Date?
    
    init(id: UUID = UUID(), name: String, typeID: UUID, startDateTime: Date, finishDateTime: Date? = nil) {
        self.id = id
        self.name = name
        self.typeID = typeID
        self.startDateTime = startDateTime
        self.finishDateTime = finishDateTime
    }
}

extension Activity {
    struct Data {
        var name = ""
        var typeID = UUID()
        var startDateTime = Date.now
        var finishDateTime: Date? = nil
    }
    
    var data: Data {
        Data(name: name, typeID: typeID, startDateTime: startDateTime, finishDateTime: finishDateTime)
    }
    
    mutating func update(from data: Data) {
        name = data.name
        typeID = data.typeID
        startDateTime = data.startDateTime
        finishDateTime = data.finishDateTime
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        typeID = data.typeID
        startDateTime = data.startDateTime
        finishDateTime = data.finishDateTime
    }
}
