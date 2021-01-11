//
//  Model.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import Foundation

//MARK: Response
struct NetworkResponse: Codable {
    let city: City
    let list: [Weather]
}

struct Weather: Codable {
    let dt: Double
    let main: Info
    let clouds: Cloud
    private let weather: [Description]?
    
    var iconUrl: String? {
        guard weather != nil else {return nil}
        if weather!.count > 0, let iconUrl = weather?.first?.icon {
            return "https://openweathermap.org/img/wn/\(iconUrl)@2x.png"
        }
        return nil
    }
}

struct City: Codable {
    let name: String
    let country: String
}

struct Info: Codable {
    let temp: Double
    let pressure: Int
    let feelsLike : Double
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case temp
        case pressure
    }
}

struct Cloud: Codable{
    let all: Int
}

struct Description: Codable {
    let icon: String
}

struct AppUser {
    var email: String
    var id: String
    var name: String?
    var currentCity: String?
}
