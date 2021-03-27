//
//  MainView.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 25.03.2021.
//

import SwiftUI

struct MainView: View {
    @State var favouriteFilterOn : Bool = false
    @ObservedObject var manager = StockManager()
    var symbols : [String] = ["AAPL", "MSFT","GOOG","AMZN","FB"]
    
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
            
            StockListView(manager: manager)
        }
        .onAppear(perform: fetchData)
        .onAppear(perform: fetchImages)
        
    }
}


struct StockListView: View{
    @ObservedObject var manager : StockManager
    var symbols : [String] = ["AAPL", "MSFT","GOOG","AMZN","FB"]
    @State var logos : [CompanyImage] = []
    @State var stocks : [Stock] = []
    
    func fetchData(){
        manager.download(symbols: symbols){_ in
            
        }
    }
    
    func fetchImages(){
        manager.downloadImages(symbols: symbols){_ in
            logos = manager.logos!
        }
    }
    
    
    init(manager : StockManager) {
        self.manager = manager
    }
    
    var body: some View{
        VStack(alignment:.leading){
            
            List(manager.stocks, id: \.symbol){item in
                        SingleStockView(name: item.companyName, ticker: item.symbol, price: item.latestPrice, delta: item.change, image: manager.logos!.count > 0 ? (manager.logos?.first(where: {$0.name == item.symbol})?.image)! : UIImage(), isColoured: true)
                    }
                    
                }.onChange(of: manager.logos?.count, perform: { value in
                    
                })
                
            
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
    var image : UIImage
    @State var isFavourite : Bool = false
    
    init(name: String, ticker: String, price: Double, delta: Double, image: UIImage, isColoured : Bool){
        
        companyName = name
        self.ticker = ticker
        currentPrice = price
        dayDelta = delta
        self.image = image
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
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    // .foregroundColor(.green)
                    // .font(.system(size: 45))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.leading, 5)
                
                
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
