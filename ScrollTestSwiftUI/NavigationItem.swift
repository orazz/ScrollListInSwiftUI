//
//  NavigationItem.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import Foundation

struct NavigationItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var path: Path
}

var navigationItems = [
    NavigationItem(title: "Kingfisher", path: .kingfisher),
    NavigationItem(title: "SDWebImage", path: .sdWebImage),
    NavigationItem(title: "Longinus", path: .longinus),
    NavigationItem(title: "CollectionView", path: .collectioView),
]

enum Path: String {
    case kingfisher
    case sdWebImage
    case longinus
    case collectioView
}
