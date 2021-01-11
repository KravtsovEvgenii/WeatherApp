//
//  DataFetcher.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import Foundation

class DataFetcher {
    static let shared = DataFetcher()
    
    func getWeather(fromStringURL stringURL: String, completion: @escaping (NetworkResponse?)->Void) {
        
        NetworkService.shared.weatherRequest(withStringURL: stringURL) {[weak self] (data, error) in
            guard error == nil else {print(error!.localizedDescription) ; return}
            if let data = data {
                let response = self?.decode(type: NetworkResponse.self, data: data)
                completion(response)
            }
        }
    }
    private func decode<T: Decodable>(type: T.Type, data: Data?)-> T?{
        let jsonDecoder = JSONDecoder()
        guard let data = data else {return nil}
        do {
        let decoded = try jsonDecoder.decode(type.self, from: data)
            return decoded
        }catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    
}


