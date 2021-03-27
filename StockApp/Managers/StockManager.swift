//
//  StockManager.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation
import UIKit

final class StockManager: ObservableObject{
    
    
    @Published var stocks = [Stock]()
    @Published var logos : [CompanyImage]? = []
    
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
    
    func downloadImages(symbols: [String], completion: @escaping (Result<[CompanyImage], NetworkError>)-> Void){
        var companyImages = [CompanyImage]()
        var imageURL : String = ""
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
