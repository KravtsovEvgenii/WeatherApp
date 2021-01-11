//
//  WeatherScenePresenter.swift
//  Weather
//
//  Created by User on 07.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WeatherScenePresentationLogic {
    func presentData(response: WeatherScene.Model.PresenterResponse.ResponseType)
}


class WeatherScenePresenter: WeatherScenePresentationLogic {
   
    weak var viewController: WeatherSceneDisplayLogic?
    let calendar = Calendar(identifier: .gregorian)
    let formatter = DateFormatter()
    func presentData(response: WeatherScene.Model.PresenterResponse.ResponseType) {
        switch response {
        case .prepareToPresent(let response):
            let cityName = response.city.name
            print(cityName)
            let countryName = response.city.country
            var items = [WeatherInfo]()
            var indexes = [Int]()
            formatter.dateFormat = "d/MMM"
            for item in response.list {
                let date = Date(timeIntervalSince1970: item.dt)
                let day = calendar.component(.day, from: date)
                if !indexes.contains(day) {
                    indexes.append(day)
                    guard let url = item.iconUrl else {return}
                    let stringDate = formatter.string(from: date)
                    
                    let weatherInfo = WeatherInfo(stringDate: stringDate,
                                                  temperature: item.main.temp,
                                                  clouds: item.clouds.all,
                                                  pressure: item.main.pressure,
                                                  feelsLikeTemp: item.main.feelsLike,
                                                  iconImageString: url)
                    items.append(weatherInfo)
                }
                
            }
            let presentableModel = PresentableWeather(cityTitle: cityName, countryTitle: countryName, weatherInfo: items)
            viewController?.displayData(viewModel: .presentData(model: presentableModel))
        }
    }
    
}
