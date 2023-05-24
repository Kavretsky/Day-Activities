//
//  UserSettings.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 23.05.2023.
//

import Foundation


struct UserSettings {
    static var positiveActivityEmoji: String = "👍"
    static var negativeActivityEmoji: String = "😡"
    
    static var positiveActivityRGBAColor = RGBAColor(red: 182/255, green: 255/255, blue: 137/255, alpha: 1)
    static var negativeActivityRGBAColor = RGBAColor(red: 255/255, green: 194/255, blue: 137/255, alpha: 1)
    
    private init() { }
}
