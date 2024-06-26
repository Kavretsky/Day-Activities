//
//  UtilityExtensions.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 23.05.2023.
//

import Foundation
import SwiftUI


struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension Date {
    func isSameDay(with comparingDate: Date) -> Bool {
        self.formatted(.dateTime.day().month().year()) == comparingDate.formatted(.dateTime.day().month().year())
    }
    
    static func endOfDay() -> Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    }
    
    static func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where:{ $0.id == element.id })
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        return String(self).containsEmoji
    }
}

extension String {
    var containsEmoji: Bool {
        let emojiPattern = #"\p{Extended_Pictographic}"#
        let range = NSRange(location: 0, length: utf16.count)
        
        if let regex = try? NSRegularExpression(pattern: emojiPattern) {
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        
        return false
    }
}

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}


