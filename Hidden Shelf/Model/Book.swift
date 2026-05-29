//
//  Book.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

struct Book: Identifiable, Codable {
    var id: String
    var title: String
    var author: String
    var genre: String
    var pages: Int
    var publisher: String
    var quote: String
    var city: String
    var isAvailable: Bool
    var ownerId: String
}
