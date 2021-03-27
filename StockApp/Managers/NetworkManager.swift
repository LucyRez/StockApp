//
//  NetworkManager.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 27.03.2021.
//

import Foundation

final class NetworkManager<T:Codable>{
    
    func fetchData(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void){
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            guard error == nil else{
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                completion(.failure(.invalidResponse(response: response!.description)))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            }catch let error{
                completion(.failure(.decodingError(err: error.localizedDescription)))
            }
        }.resume()
    }
    
   
}

enum NetworkError : Error{
    case error(err: String)
    case invalidResponse(response: String)
    case invalidData
    case decodingError(err: String)
}
