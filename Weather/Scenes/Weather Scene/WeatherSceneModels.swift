//
//  WeatherSceneModels.swift
//  Weather
//
//  Created by User on 07.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct PresentableWeather {
    var cityTitle: String
    var countryTitle: String
    var weatherInfo: [WeatherInfo] 
}

struct WeatherInfo {
    private let formatter = DateFormatter()
    
    var stringDate: String
    var temperature: Double
    var clouds: Int
    var pressure: Int
    var feelsLikeTemp: Double
    var iconImageString: String
    
    
}

enum WeatherScene {
  enum Model {
    struct Request {
      enum RequestType {
        case getNewWeatherData(city: String?)
      }
    }
    struct PresenterResponse {
      enum ResponseType {
        case prepareToPresent(response: NetworkResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case presentData(model: PresentableWeather)
      }
    }
  }
  
}
