//
//  CityManager.swift
//  TryWeatherAppV2
//
//  Created by Алина on 10.05.2024.
//

import Foundation

final class CityListManager {
    
    // MARK: - Init
    static let shared = CityListManager()
    let cityListKey = "city"
    private init() {}
    
    
    // MARK: - Data func
    func saveCity(_ cityName: String) {
        var cities = loadCity()
        cities.append(cityName)
        UserDefaults.standard.set(cities, forKey: cityListKey)
    }
    
    func loadCity() -> [String] {
        if let savedCities = UserDefaults.standard.stringArray(forKey: cityListKey) {
            return savedCities
        }
        return []
    }
        
    func deleteCityFromUserDefaults(_ cityName: String) {
        var cities = loadCity()
        if let index = cities.firstIndex(of: cityName) {
            cities.remove(at: index)
            UserDefaults.standard.set(cities, forKey: cityListKey)
        }
    }
}
