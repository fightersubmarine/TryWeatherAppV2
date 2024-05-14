//
//  CityListViewModel.swift
//  TryWeatherAppV2
//
//  Created by Алина on 10.05.2024.
//

import Foundation

final class CityListViewModel {
    
    //MARK: - Properties
    private let cityListManager = CityListManager.shared
    
    
    func saveCity(_ cityName: String) {
        cityListManager.saveCity(cityName)
    }
    
    func deleteCity(_ cityName: String) {
        cityListManager.deleteCityFromUserDefaults(cityName)
    }
    
    func getAllCities() -> [String] {
        return cityListManager.loadCity()
    }
    
    func cityExists(_ cityName: String) -> Bool {
        let cities = cityListManager.loadCity()
        return cities.contains(cityName)
    }
    
}
