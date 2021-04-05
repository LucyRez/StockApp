//
//  InfoView.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 05.04.2021.
//

import Foundation
import SwiftUI

struct InfoView: View {
    
    
    let stockModel : StockInListModel
    
    init(stock: StockInListModel){
        stockModel = stock
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            Text("Info")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding()
            
            Spacer()
            
            Image(uiImage: stockModel.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.leading, 5)
            
            HStack{
                VStack(spacing: 20){
                    Text("Company Name:")
                        .bold()
                    
                    Text("Ticker:")
                        .bold()
                    
                    Text("Current Price:")
                        .bold()
                    
                    Text("Change In 24 Hours:")
                        .bold()
                    
                    Text("Change In Percent:")
                        .bold()
                }
                
                VStack(spacing: 20){
                    Text(stockModel.companyName)
                    Text(stockModel.symbol)
                    Text(String(format:"$%.2f", stockModel.latestPrice))
                    Text(stockModel.change > 0 ? String(format:"+%.2f", stockModel.change) : String(format:"%.2f", stockModel.change))
                    
                    
                    Text(stockModel.change > 0 ? String(format:"(%.2f", stockModel.changePercent) + "%)" : String(format:"(%.2f", stockModel.changePercent) + "%)")
                    
                    
                }
                
            }
            .font(.system(size: 18))
            
            Spacer()

        }
    }
    
}

