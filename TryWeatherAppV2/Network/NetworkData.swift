//
//  NetworkData.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//

import Foundation


struct WeatherResponse: Decodable {
    struct Location: Decodable {
        let name: String
        let localtime: String
    }
    
    struct Current: Decodable {
        let temp_c: Double
        let condition: Condition
        let wind_kph: Double
    }
    
    struct Condition: Decodable {
        let text: String
    }
    
    struct Forecast: Decodable {
        let forecastday: [ForecastDay]
        
        struct ForecastDay: Decodable {
            let date: String
            let day: Day
        }
        
        struct Day: Decodable {
            let maxtemp_c: Double
            let condition: Condition
        }
    }
    
    let location: Location
    let current: Current
    let forecast: Forecast
}
