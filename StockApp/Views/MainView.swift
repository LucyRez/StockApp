//
//  MainView.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 25.03.2021.
//

import SwiftUI

struct MainView: View {
    @State var favouriteFilterOn : Bool = false
    
    var body: some View {
        VStack{
            SearchBarView()
            HStack{
                Button(action: {
                    favouriteFilterOn = false
                },
                label: {
                    Text("Stocks")
                        .font(.system(size: favouriteFilterOn ? 22 : 35))
                        .bold()
                        .foregroundColor(.black)
                        .opacity(favouriteFilterOn ? 0.4 : 0.8)
                    
                })
                
                Button(action: {
                    favouriteFilterOn = true
                },
                label: {
                    Text("Favourite")
                        .font(.system(size: favouriteFilterOn ? 35 : 22))
                        .bold()
                        .foregroundColor(.black)
                        .opacity(favouriteFilterOn ? 0.8 : 0.4)
                        .padding(.horizontal)
                        
                    
                })
                
                Spacer()
            }.padding(.horizontal)
            
            StockListView()
        }
    }
}


struct StockListView: View{
    var body: some View{
        VStack(alignment:.leading){
            
            List{
                SingleStockView(name: "Yandex, LLC", ticker: "YNDX", price: 1234.789847, delta: 0.765, isColoured: true)
            }
            
        }
    }
}

struct SearchBarView: View{
    @State var str: String = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 60)
                .fill(Color(red: 240/255, green: 244/255, blue: 247/255, opacity: 1))
                .frame(width: .infinity, height: 50)
                .padding()
            
            TextField("Search", text: $str)
                .padding(30)
        }
    }
}

struct SingleStockView: View{
    
    var color : Color
    var companyName : String
    var ticker : String
    var currentPrice : Double
    var dayDelta : Double
    @State var isFavourite : Bool = false
    
    init(name: String, ticker: String, price: Double, delta: Double, isColoured : Bool){
        
        companyName = name
        self.ticker = ticker
        currentPrice = price
        dayDelta = delta
        if isColoured == true {
            color = Color(red: 240/255, green: 244/255, blue: 247/255, opacity: 1)
        }else{
            color = Color(.white)
        }
    }
    
    var body: some View{
        
        ZStack(alignment:.topLeading){
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: .infinity, height: 80)
            HStack{
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 45))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.leading, 15)
                
                
                VStack(alignment: .leading){
                    HStack{
                        Text(ticker)
                            .bold()
                            .font(.system(size: 25))
                        Button(action: {
                            isFavourite.toggle()
                            
                        }, label: {
                            
                            if(isFavourite == true){
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                                
                            }else{
                                Image(systemName: "star")
                                    .font(.system(size: 20))
                            }
                        })
                    }
                    Text(companyName)
                }
                
                Spacer()
                
                VStack(alignment:.leading){
                    Text(String(format:"%.2f", currentPrice))
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                    
                    
                    
                    Text(String(format:"%.2f", dayDelta))
                        .bold()
                        .foregroundColor(.green)
                        .font(.system(size: 15))
                    
                    
                }
                .padding()
                
                
            }
            
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
