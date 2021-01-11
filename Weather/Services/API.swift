//
//  API.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import Foundation

struct API {
    static let apiKey = "ec471b22a225a65d34d5aed07341f0e3"
   
    static func getStringURL(forCity city: String?) -> String{
        if let tempCity = city {
            return "https://api.openweathermap.org/data/2.5/forecast?q=\(tempCity)&id=524901&units=metric&appid=\(apiKey)"
        }
    return "https://api.openweathermap.org/data/2.5/forecast?id=524901&&units=metric&appid=\(apiKey)"
    }
}
