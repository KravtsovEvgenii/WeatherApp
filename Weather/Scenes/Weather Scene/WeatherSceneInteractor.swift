//
//  WeatherSceneInteractor.swift
//  Weather
//
//  Created by User on 07.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WeatherSceneBusinessLogic {
  func makeRequest(request: WeatherScene.Model.Request.RequestType)
}

class WeatherSceneInteractor: WeatherSceneBusinessLogic {

  var presenter: WeatherScenePresentationLogic?
  var service: WeatherSceneService?
  
  func makeRequest(request: WeatherScene.Model.Request.RequestType) {
    if service == nil {
      service = WeatherSceneService()
    }
    
    switch request {
    case .getNewWeatherData(let city):
        let string = API.getStringURL(forCity: city)
        DataFetcher.shared.getWeather(fromStringURL: string) { [weak self](response) in
            if let response = response {
                self?.presenter?.presentData(response: .prepareToPresent(response: response))
            }
        }
        
    }
  }
  
    
    
}
