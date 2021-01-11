//
//  NetworkService.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import Foundation
import UIKit
class NetworkService {
    static let shared = NetworkService()
    var currentURL: String?
    
    func weatherRequest(withStringURL stringURL: String, completion: @escaping (Data?,Error?)-> Void) {
        guard let url = URL(string: stringURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            completion(data,error)
        }
        task.resume()
    }
    
    func getWeatherIcon(fromStringUrl stringUrl: String, completion: @escaping (UIImage?)-> Void) {
        guard let url = URL(string: stringUrl) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }
        task.resume()
        
    }
}



