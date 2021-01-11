//
//  WebImageView.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import UIKit

class WebImageView: UIImageView{
    var currentURL: String?
    
    func setImage(fromString string: String){
        
        currentURL = string
        if let url = URL(string: string){
            // Проверяем существует ли изображение с таким урл. Если да то берем его.
            if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)){
                self.image = UIImage(data: cachedResponse.data)
                return
            }
            
            let dataTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                // Устанавливаем картинку на главном потоке
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {return}
                    self?.handleImageData(data: data, response: response)
                }
            }
            dataTask.resume()
        }
    }
    //Кэшируем скачанные данные для повторного использования
    private func handleImageData(data: Data, response: URLResponse) {
        guard let responseURL = response.url else {return}
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        if responseURL.absoluteString == currentURL {
            self.image = UIImage(data: data)
        }
        
    }
}

