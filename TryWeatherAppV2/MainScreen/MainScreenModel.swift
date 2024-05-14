//
//  MainScreenModel.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//

import Foundation

struct Weather {
    let city: String
    let today: DailyForecast
    let forecast: [DailyForecast]
    
    init(response: WeatherResponse) {
        self.city = response.location.name
        self.today = DailyForecast(day: response.current)
        self.forecast = response.forecast.forecastday.map { DailyForecast(forecastDay: $0) }
    }
}

struct DailyForecast {
    let date: String
    let temperature: String
    let description: String
    let windSpeed: String
        
    init(day: WeatherResponse.Current) {
        self.date = ""
        self.temperature = "\(day.temp_c)"
        self.description = day.condition.text
        self.windSpeed = "\(day.wind_kph)"
    }
    
    init(forecastDay: WeatherResponse.Forecast.ForecastDay) {
        self.date = forecastDay.date
        self.temperature = "\(forecastDay.day.maxtemp_c)"
        self.description = forecastDay.day.condition.text
        self.windSpeed = ""
    }
}

// MARK: - Formatted Properties

extension DailyForecast {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateObj = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM"
            return dateFormatter.string(from: dateObj)
        } else {
            return "Invalid Date"
        }
    }
    
    var formattedWindSpeed: String {
        if let kph = Double(windSpeed) {
            let mps = kph * 1000 / 3600
            return String(format: "%.2f", mps)
        } else {
            return "Invalid Speed"
        }
    }

}
