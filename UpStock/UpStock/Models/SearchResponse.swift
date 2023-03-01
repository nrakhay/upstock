//
//  SearchResponse.swift
//  UpStock
//
//  Created by Nurali Rakhay on 01.03.2023.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResults]
}

struct SearchResults: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
