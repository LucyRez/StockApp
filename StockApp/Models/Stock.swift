//
//  Stock.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 26.03.2021.
//

import Foundation

struct Stock : Codable{
    var companyName : String
    var symbol : String
    var latestPrice : Double
    var change : Double
    var changePercent : Double
  //  var isFavourite : Bool = false
    
    
    private enum Keys: String, CodingKey{
        case companyName = "companyName"
        case symbol = "symbol"
        case latestPrice = "latestPrice"
        case change = "change"
        case changePercent = "changePercent"
    }
}
