//
//  NewsResponse.swift
//  UpStock
//
//  Created by Nurali Rakhay on 07.03.2023.
//

import Foundation

struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
