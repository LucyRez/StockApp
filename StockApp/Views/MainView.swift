//
//  MainView.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 25.03.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var manager = StockManager()
    @State var favourites : [Stock] = []
    var symbols : [String] = ["AAPL", "MSFT","GOOGL","AMZN","FB", "TSLA", "MA", "BAC", "YNDX", "DIS", "GE"]
    
    func fetchData(){
        manager.download(symbols: symbols){_ in
            
        }
    }
    
    func fetchImages(){
        manager.downloadImages(symbols: symbols){_ in
            
        }
    }
    
    
    
    var body: some View {
        VStack{
            SearchBarView(manager: manager)
            HStack{
                Button(action: {
                    manager.favouriteFilterOn = false
                },
                label: {
                    Text("Stocks")
                        .font(.system(size: manager.favouriteFilterOn ? 22 : 35))
                        .bold()
                        .foregroundColor(.black)
                        .opacity(manager.favouriteFilterOn ? 0.4 : 0.8)
                    
                })
                
                Button(action: {
                    manager.favouriteFilterOn = true
                },
                label: {
                    Text("Favourite")
                        .font(.system(size: manager.favouriteFilterOn ? 35 : 22))
                        .bold()
                        .foregroundColor(.black)
                        .opacity(manager.favouriteFilterOn ? 0.8 : 0.4)
                        .padding(.horizontal)
                    
                    
                })
                
                Spacer()
            }.padding(.horizontal)
            
            StockListView(manager: manager)
        }
        .onAppear(perform: fetchData)
        .onAppear(perform: fetchImages)
        
    }
}


struct StockListView: View{
    @ObservedObject var manager : StockManager
    
    init(manager : StockManager) {
        self.manager = manager
        
    }
    
    var body: some View{
        VStack(alignment:.leading){
            
            if manager.favouriteFilterOn == false{
                List(manager.stocks, id: \.symbol){item in
                    SingleStockView(manager: manager, name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, image: manager.logos!.count > 0 ? (manager.logos?.first(where: {$0.name == item.symbol})?.image)! : UIImage(), isFavourite: manager.checkInFavourites(ticker: item.symbol) )
                }
                
            }else{
                List(manager.favourites, id: \.symbol){item in
                    SingleStockView(manager: manager, name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, image: manager.logos!.count > 0 ? (manager.logos?.first(where: {$0.name == item.symbol})?.image)! : UIImage(), isFavourite: true)
                    
                }
            }  
            
        }
        
        
        
    }
}

struct SearchBarView: View{
     @State var str: String = ""
     @ObservedObject var manager : StockManager
    
    func search(by ticker: String){
        let trimmed = ticker.trimmingCharacters(in: .whitespacesAndNewlines)
        var tickerWrap = [String]()
        tickerWrap.append(trimmed)
        
        manager.download(symbols: tickerWrap){_ in
            
        }
     
        manager.downloadImages(symbols: tickerWrap){_ in
            
        }
        
       
    }
    
    var body: some View{
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color(red: 240/255, green: 244/255, blue: 247/255, opacity: 1))
                    .frame(width: .infinity, height: 50)
                    .padding()
                
                TextField("Search", text: $str)
                    .padding(30)
            }
            
            Button(action: {search(by: str)}, label: {
                Image(systemName: "magnifyingglass")
            })
            .padding()
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
