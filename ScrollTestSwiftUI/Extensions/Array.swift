//
//  Array.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import Foundation
// Extension to check if an item is the last one in the array
extension Array where Element: Identifiable {
    func isLastItem(_ item: Element) -> Bool {
        guard let itemIndex = firstIndex(where: { $0.id == item.id }) else {
            return false
        }
        return itemIndex == count - 1
    }
}
