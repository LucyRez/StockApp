//
//  Stock.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 26.03.2021.
//

import Foundation

// Модель акции (такой же формат подаёт нам API)
// учавствует только при декодировании
struct Stock : Codable{
    var companyName : String
    var symbol : String
    var latestPrice : Double
    var change : Double
    var changePercent : Double
    
    
    private enum Keys: String, CodingKey{
        case companyName = "companyName"
        case symbol = "symbol"
        case latestPrice = "latestPrice"
        case change = "change"
        case changePercent = "changePercent"
    }
}
