//
//  ShelfEnum.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation


enum ViewMode {
    case card
    case list
}

enum ShelfStatus: String, Codable {
    case available = "Available"
    case swapped = "Swapped"
}

enum SortOption: String, CaseIterable {
    case newest = "Newest Added"
    case alphabetical = "A - Z Alphabetical"
}

enum PageRangeOption: String, CaseIterable {
    case all = "All Pages"
    case short = "Short (< 150 pgs)"
    case medium = "Medium (150 - 400 pgs)"
    case long = "Long (> 400 pgs)"
}
