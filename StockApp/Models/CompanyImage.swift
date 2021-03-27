//
//  CompanyImage.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation
import UIKit

struct CompanyImage {
    let image : UIImage
    let name : String
    
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
}
