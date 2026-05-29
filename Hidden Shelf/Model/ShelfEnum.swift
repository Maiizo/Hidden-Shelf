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
