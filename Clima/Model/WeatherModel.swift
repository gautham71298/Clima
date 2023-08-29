//
//  WeatherModel.swift
//  Clima
//
//  Created by Gautham on 29/06/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
  let conditionId: Int
  let temp: Double
  let name: String
  
  var conditionName: String {
    switch conditionId {
    case 200...299:
      return "cloud.bolt.rain"
    case 300...399:
      return "cloud.drizzle"
    case 500...599:
      return "cloud.rain"
    case 600...699:
      return "cloud.snow"
    case 700...799:
      return "cloud.fog"
    case 800:
      return "cloud"
    case 801...899:
      return "cloud.sun"
    default:
      return "cloud"
    }
  }
  
  var tempString: String {
    return String(format: "%.1f", temp)
  }
}
