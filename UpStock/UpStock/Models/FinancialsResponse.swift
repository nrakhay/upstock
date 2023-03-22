//
//  FinancialsResponse.swift
//  UpStock
//
//  Created by Nurali Rakhay on 22.03.2023.
//

import Foundation

struct FinancialsResponse: Codable {
    let metric: Metric
}

struct Metric: Codable {
    let tenDayAverageTradingVolume: Float
    let annualHigh: Float
    let annualLow: Float
    let annualLowDate: String
    let annualWeekPriceReturnDaily: Float
    let beta: Float
    
    enum CodingKeys: String, CodingKey {
        case tenDayAverageTradingVolume = "10DayAverageTradingVolume"
        case annualHigh = "52WeekHigh"
        case annualLow = "52WeekLow"
        case annualLowDate = "52WeekLowDate"
        case annualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
        case beta = "beta"
    }
}

