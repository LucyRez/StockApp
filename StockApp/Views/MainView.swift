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
    
    // Изначальные тикеры.
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
        .onAppear(perform: fetchData) // Собираем изображения и акции.
        .onAppear(perform: fetchImages)
        
    }
}


struct StockListView: View{
    @ObservedObject var manager : StockManager
    
    init(manager : StockManager) {
        self.manager = manager
        
    }
    
    func clearSearch(){
        manager.searchStocks = []
    }
    
    var body: some View{
        VStack(alignment:.leading){
            
            if manager.favouriteFilterOn == false{
                if  manager.search != ""{
                    if manager.searchStocks.count > 0 {
                        List(manager.searchStocks, id: \.symbol){item in
                            SingleStockView(manager: manager, name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, deltaPercent: item.changePercent, image: (manager.searchLogos.count > 0 ? (manager.searchLogos.first(where: {$0.name == item.symbol})?.image) : UIImage()) ?? UIImage(), isFavourite: manager.checkInFavourites(ticker: item.symbol) )
                        }
                    }else{
                        Spacer()
                        Text("Searching...")
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                }else{
                    List(manager.stocks, id: \.symbol){item in
                        SingleStockView(manager: manager, name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, deltaPercent: item.changePercent, image: (manager.logos?.count ?? 0 > 0 ? (manager.logos?.first(where: {$0.name == item.symbol})?.image) : UIImage()) ?? UIImage(), isFavourite: manager.checkInFavourites(ticker: item.symbol) )
                    }
                    .onAppear(perform: clearSearch)
                    
                }
                
            }
            else{
                List(manager.favourites, id: \.symbol){item in
                    SingleStockView(manager: manager, name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, deltaPercent: item.changePercent, image:(manager.logos?.count ?? 0 > 0 ? (manager.logos?.first(where: {$0.name == item.symbol})?.image) : UIImage()) ?? UIImage(), isFavourite: true)
                    
                }
            }  
            
        }
        
    }
}

struct SearchBarView: View{
    @ObservedObject var manager : StockManager
    
    func search(by ticker: String){
        let trimmed = ticker.trimmingCharacters(in: .whitespacesAndNewlines)
        var tickerWrap = [String]()
        tickerWrap.append(trimmed.uppercased())
        
        manager.download(symbols: tickerWrap){_ in
            
        }
        
        manager.downloadImages(symbols: tickerWrap){_ in
            
        }
        
        
        
    }
    
    var body: some View{
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: .infinity, height: 50)
                    .padding()
                
                TextField("Find ticker", text: $manager.search)
                    .padding(30)
                    
            }
            
            Button(action: {search(by: manager.search)}, label: {
                Image(systemName: "magnifyingglass")
            })
            .font(.system(size: 25))
            .padding(.leading, -20)
            .padding(.trailing, 10)
            .accentColor(Color.black)
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
