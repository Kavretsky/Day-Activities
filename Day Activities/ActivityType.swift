//
//  ActivityType.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 18.06.2023.
//

import Foundation
import SwiftUI

enum ActivityType: CaseIterable {
    case positive
    case negative
    
    var label: String {
        switch self {
        case .negative: return UserSettings.negativeActivityEmoji
        case .positive: return UserSettings.positiveActivityEmoji
        }
    }
    
    var color: Color {
        switch self {
        case .positive:
            return Color(rgbaColor: UserSettings.positiveActivityRGBAColor)
        case .negative:
            return Color(rgbaColor: UserSettings.negativeActivityRGBAColor)
        }
    }
    
    var description: String {
        switch self {
        case .positive:
            return "Positive"
        case .negative:
            return "Negative"
        }
    }
    
}
