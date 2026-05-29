//
//  OpenLibraryService.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

class OpenLibraryService {
    func searchBooks(query: String) async throws -> [OpenLibraryDoc] {
        guard !query.isEmpty else { return [] }
        
        let sanitizedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://openlibrary.org/search.json?q=\(sanitizedQuery)&limit=7"
        
        // FIXED: Using standard native URL(string:) initializer
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
        return decodedResponse.docs
    }
}
