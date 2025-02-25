//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  var weatherManager = WeatherManager()
  var locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    weatherManager.delegate = self
    searchTextField.delegate = self
    
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
}


// MARK: - Search methods

extension WeatherViewController: UITextFieldDelegate {
  
  @IBAction func searchPressed(_ sender: UIButton) {
    searchTextField.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Type something"
      return false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    searchTextField.placeholder = "Search"
    searchTextField.text = ""
  }
}


// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
  
  func didUpdateWeather(_ manager: WeatherManager, weather: WeatherModel) {
    DispatchQueue.main.async {
      self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      self.temperatureLabel.text = weather.tempString
      self.cityLabel.text = weather.name
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}


// MARK: - LocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
  @IBAction func myLocationPressed(_ sender: UIButton) {
    locationManager.requestLocation()
  }
  
}
