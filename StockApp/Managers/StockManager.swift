//
//  StockManager.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation
import UIKit
// Данный класс отвечает за основную логику приложения.
final class StockManager: ObservableObject{
    
    @Published var stocks = [Stock]() // Все получаемые акции.
    @Published var logos : [CompanyImage]? = [] // Все изображения компаний.
    @Published var favourites = [StockInListModel]() // Массив для записи фаворитов.
    @Published var favouriteFilterOn = false // Булевая переменная указывает включен ли фильтр по фаворитам.
   
    // Функция проверяет, принадлежит ли акция к фаворитам или нет.
    func checkInFavourites(ticker: String) -> Bool{
        for item in favourites {
            if item.symbol == ticker {
                return true
            }
        }
        return false
    }
    
    // Функция осуществляет добавление акции в массив фаворитов.
    func addToFavourites(stock: StockInListModel){
        for st in favourites {
            if st.symbol == stock.symbol {
                return
            }
        }
        favourites.append(stock)
    }
    
    // Функция осуществляет удаление из массива.
    func removeFromFavourites(stock: StockInListModel){
        var index : Int = 0
        for st in favourites {
            if st.symbol == stock.symbol {
                favourites.remove(at: index)
            }
            index+=1
        }
    }
    
    // Функция осуществляет скачивание всех акций и запись их в массив.
    func download(symbols: [String], completion: @escaping (Result<[Stock],NetworkError>)-> Void){
        var stockArray = [Stock]()
        let downloadQueue = DispatchQueue(label: "downloadStock")
        let downloadGroup = DispatchGroup()
        
        symbols.forEach{(symbol) in
            downloadGroup.enter()
            let url = URL(string: APIManager.getQuoteURL(for: symbol))!
            NetworkManager<Stock>().fetchData(url: url){(result) in
                switch(result){
                case .failure(let err):
                    print(err)
                    downloadQueue.async {
                        downloadGroup.leave()
                    }
                case .success(let response):
                    downloadQueue.async {
                        stockArray.append(response)
                        downloadGroup.leave()
                    }
                }
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.global()){
            completion(.success(stockArray))
            DispatchQueue.main.async {
                    self.stocks.append(contentsOf: stockArray)

            }
        }
    }
    
    
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?)->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Функция осуществляет скачивание всех изображений и запись их в массив.
    func downloadImages(symbols: [String], completion: @escaping (Result<[CompanyImage], NetworkError>)-> Void){
        var companyImages = [CompanyImage]()
        let downloadQueue = DispatchQueue(label: "downloadImages")
        let downloadGroup = DispatchGroup()
        
        symbols.forEach{(symbol) in
            downloadGroup.enter()
            let url = URL(string: APIManager.getImageURL(for: symbol))!
            NetworkManager<ImageURL>().fetchData(url: url){(result) in
                switch(result){
                case .failure(let err):
                    print(err)
                    downloadQueue.async {
                        downloadGroup.leave()
                    }
                case .success(let response):
                    print(response)
                    downloadQueue.async {
                        self.getImage(from: URL(string: response.url)!) { data, response, error in
                            guard let data = data, error == nil else {return}
                            companyImages.append(CompanyImage(image: UIImage(data: data) ?? UIImage(), name: symbol))
                            downloadGroup.leave()
                        }
                    }
                }
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.global()){
            completion(.success(companyImages))
            DispatchQueue.main.async {
              
                    self.logos!.append(contentsOf: companyImages)
                
            }
        }
        
    }
}
