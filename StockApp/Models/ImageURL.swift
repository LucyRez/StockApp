//
//  ImageURL.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation

// Модель для ссылки на изображение (такую же получаем от API)
struct ImageURL : Codable{
    var url : String

    private enum Keys: String, CodingKey{
        case url = "url"
    }
}
