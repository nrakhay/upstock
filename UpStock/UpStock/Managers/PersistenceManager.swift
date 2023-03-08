//
//  PersistenceManager.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        static let onboardedKey = "hasOnBoarded"
        static let watchlistKey = "watchlist"
    }
    
    private init() { }
    
    //MARK: - Public
    public var watchlist: [String] {
        if (!hasOnBoarded) {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setupDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    
    //MARK: - Private
    private var hasOnBoarded: Bool {
        return userDefaults.bool(forKey: "hasOnBoarded")
    }
    
    private func setupDefaults() {
        let map: [String:String] = [
            "AAPL": "Apple Inc.",
            "TSLA": "Tesla Inc.",
            "GOOG": "Alphabet",
            "MSFT": "Microsoft Corporation",
            "AMZN": "Amazon.com Inc.",
            "NVDA": "Nvidia Inc.",
            "FB": "Facebook Inc.",
            "UBER": "Uber Technologies Inc.",
            "NKE:": "Nike",
            "PINS": "Pinterest Inc."
        ]
        
        let symbols = map.keys.map { $0 }
        
        userDefaults.set(symbols, forKey: "watchlist")
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
