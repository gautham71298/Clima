//
//  WeatherManager.swift
//  Clima
//
//  Created by Gautham on 22/05/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ manager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let weatherAPIUrl = "https://api.openweathermap.org/data/2.5/weather?appid=9e152c3e3cb5c8e84bab85acf3b8c481&units=metric"
  
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather(cityName: String) {
    let urlString = "\(weatherAPIUrl)&q=\(cityName)"
    performRequest(with: urlString)
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherAPIUrl)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }
  
  private func performRequest(with urlString: String) {
    let url = URL(string: urlString)
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: url!, completionHandler: {(data, responseHeaders, error) in
      if error != nil {
        self.delegate?.didFailWithError(error: error!)
      }
      
      if let safeData = data {
        if let weather = self.parseJson(safeData) {
          delegate?.didUpdateWeather(self, weather: weather)
        }
      }
    }).resume()
  }
  
  private func parseJson(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name
      return WeatherModel(conditionId: id, temp: temp, name: name)
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
