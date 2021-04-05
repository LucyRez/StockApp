//
//  StockInListModel.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import Foundation
import UIKit

// Другое представление для акции
struct StockInListModel{
    var companyName : String
    var symbol : String
    var latestPrice : Double
    var change : Double
    var changePercent : Double
    var logo : UIImage
    var isFavourite : Bool
    
    init(name: String, ticker: String, price: Double, delta: Double, deltaPercent: Double, image: UIImage, isFavourite: Bool){
        
        companyName = name
        symbol = ticker
        latestPrice = price
        change = delta
        logo = image
        changePercent = deltaPercent
        self.isFavourite = isFavourite
    }
    
    
}
