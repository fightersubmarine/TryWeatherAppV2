//
//  MainScreenViewModel.swift
//  TryWeatherAppV2
//
//  Created by Алина on 08.05.2024.
//

import Foundation
import RxSwift

enum changeRequest {
    case location
    case searchCity
    case cityFromTableView
}

final class MainScreenViewModel {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    private let weatherSubject = BehaviorSubject<Weather?>(value: nil)
    public var weatherObservable: Observable<Weather?> {
        return weatherSubject.asObservable()
    }
    
    private let weatherSubjectForecast = BehaviorSubject<[DailyForecast]>(value: [])
    public var weatherObservableForecast: Observable<[DailyForecast]> {
        return weatherSubjectForecast.asObservable()
    }
    
    weak var mainScreenView: MainScreenViewController?
    private var forecastData: [DailyForecast] = []
    
    let selectionSubject = PublishSubject<changeRequest>()
    public var selectionObservable: Observable<changeRequest> {
        return selectionSubject.asObservable()
    }
    
    // MARK: - Init
    
    init() {        
        selectionObservable
            .subscribe(onNext: {
                [weak self] selection in
                self?.fetchWeather(for: selection)
            })
            .disposed(by: disposeBag)
    }
        
    // MARK: - Update data functions
        
    func fetchWeather(for request: changeRequest) {
        switch request {
        case .location:
            print("Fetching weather for current location...")
            makeDataRequestForLocation()
            
        case .searchCity:
           if let cityName = CityListManager.shared.loadCity().last {
               makeDataRequestForCityName(forCity: cityName)
           } else {
               makeDataRequestForLocation()
           }
            
        case .cityFromTableView:
            if let selectedCity = UserDefaults.standard.string(forKey: "selectedCity") {
                makeDataRequestForCityName(forCity: selectedCity)
                UserDefaults.standard.removeObject(forKey: "selectedCity")
            } else {
                makeDataRequestForLocation()
            }
        }
    }
    
    func makeDataRequestForLocation() {
        networkManager.loadWeatherData()
        networkManager.weatherDataObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] weatherResponse in
                guard let weatherResponse = weatherResponse else { return }
                let weather = Weather(response: weatherResponse)
                self?.weatherSubject.onNext(weather)
                self?.forecastData = weather.forecast
                self?.weatherSubjectForecast.onNext(weather.forecast)
            })
            .disposed(by: disposeBag)
    }
    
    func makeDataRequestForCityName(forCity cityName: String) {
        networkManager.makeDataRequestForCityName(forCity: cityName)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { weatherResponse in
                let weather = Weather(response: weatherResponse)
                self.weatherSubject.onNext(weather)
                self.forecastData = weather.forecast
                self.weatherSubjectForecast.onNext(weather.forecast)
            })
            .disposed(by: disposeBag)
    }
    
    func getForecastData() -> [DailyForecast] {
        return forecastData
    }
}


