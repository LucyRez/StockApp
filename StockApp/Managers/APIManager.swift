//
//  APIManager.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation

struct APIManager{
    
    static var baseURL : String{
        return "https://cloud.iexapis.com/v1/stock"
    }
    
    private static func getURL(by key: QueryKeys, symbol: String) -> String{
        switch key{
        case .list:
                return "\(baseURL)/\(key.rawValue)?&token=\(token)"
        case .logo:
                return "\(baseURL)/\(symbol)/\(key.rawValue)?token=\(token)"
        case .quote:
            return "\(baseURL)/\(symbol)/\(key.rawValue)?token=\(token)"
        }
    }
    
    static func getQuoteURL(for symbol: String) -> String{
        getURL(by: .quote , symbol: symbol)
    }
    
    static func getImageURL(for symbol: String) -> String{
        getURL(by: .logo, symbol: symbol)
    }
    
    
    private enum QueryKeys: String{
        case quote = "quote"
        case logo = "logo"
        case list = "market/list/mostactive"
    }
}

extension APIManager{
    static var token : String{
        return "pk_25e21941845c4f51a74fe798445e666c"
    }
}
