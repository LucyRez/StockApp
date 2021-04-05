//
//  SingleStockView.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import SwiftUI

struct SingleStockView: View {
    @ObservedObject var manager : StockManager
    @State var showInfo = false
    var stock : StockInListModel
    
    @State var isFavourite : Bool = false
    
    init(manager: StockManager, name: String, ticker: String, price: Double, delta: Double, deltaPercent: Double, image: UIImage, isFavourite: Bool){
        
        self.manager = manager
        stock = StockInListModel(name: name, ticker: ticker, price: price, delta: delta, deltaPercent: deltaPercent , image: image, isFavourite: isFavourite)
        
    }
    
    var body: some View{
        
        ZStack(alignment:.topLeading){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 240/255, green: 244/255, blue: 247/255, opacity: 1))
                .frame(width: .infinity)
                .fixedSize(horizontal: false, vertical: false)
            HStack{
                Image(uiImage: stock.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.leading, 5)
                
                
                VStack(alignment: .leading){
                    HStack{
                        Text(stock.symbol)
                            .bold()
                            .font(.system(size: 25))
                        Button(action: {
                            
                            if (!stock.isFavourite){
                                isFavourite = true
                                manager.addToFavourites(stock:
                                                            StockInListModel(name: stock.companyName, ticker: stock.symbol, price: stock.latestPrice, delta: stock.change, deltaPercent: stock.changePercent, image: stock.logo, isFavourite: true))
                            }else{
                                manager.removeFromFavourites(stock: stock)
                                isFavourite = false
                            }
                            
                        }, label: {
                            
                            if(stock.isFavourite || isFavourite){
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                                
                            }else{
                                Image(systemName: "star")
                                    .font(.system(size: 20))
                            }
                        })
                    }
                    Text(stock.companyName)
                }
                
                Spacer()
                
                VStack(alignment:.leading){
                    Text(String(format:"$%.2f", stock.latestPrice))
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                    
                    
                    HStack{
                        Text(stock.change > 0 ? String(format:"+%.2f", stock.change) : String(format:"%.2f", stock.change))
                            .bold()
                            .foregroundColor(stock.change > 0 ? .green : .red)
                            .font(.system(size: 13))
                        
                        Text(stock.change > 0 ? String(format:"(%.2f", stock.changePercent) + "%)" : String(format:"(%.2f", stock.changePercent) + "%)")
                            .bold()
                            .foregroundColor(stock.change > 0 ? .green : .red)
                            .font(.system(size: 11))
                    }
                    
                    
                }
                
                .padding()
                
            }
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {
                    showInfo.toggle()
                },
                label:{
                    HStack{
                        Text("Info")
                        Image(systemName: "info.circle")
                    }
                })
               
            }))
            .sheet(isPresented: $showInfo, onDismiss: {
                showInfo = false
            }, content:{
                InfoView(stock: stock)
            })
            
        }
        
    }
}

