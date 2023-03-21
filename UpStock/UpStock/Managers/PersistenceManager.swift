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
    
    public func watchlistContainsSymbol(symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    public func addToWatchlist(symbol: String, companyName: String) {
        var newList = watchlist
        newList.append(symbol)
        
        userDefaults.set(newList, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    public func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        
        userDefaults.set(nil, forKey: symbol)
        
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchlistKey)
    }
    
    
    //MARK: - Private
    private var hasOnBoarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    private func setupDefaults() {
        let map: [String:String] = [
            "AAPL": "Apple Inc.",
            "TSLA": "Tesla Inc.",
            "GOOG": "Alphabet",
            "MSFT": "Microsoft Corporation",
            "AMZN": "Amazon.com Inc.",
            "NVDA": "Nvidia Inc.",
            "META": "Facebook Inc.",
            "UBER": "Uber Technologies Inc.",
            "NKE": "Nike Inc.",
            "PINS": "Pinterest Inc."
        ]
        
        let symbolsList = map.keys.map { $0 }
        
        userDefaults.set(symbolsList, forKey: "watchlist")
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
