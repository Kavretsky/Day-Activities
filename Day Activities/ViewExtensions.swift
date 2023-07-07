//
//  ViewExtensions.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 07.07.2023.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
