//
//  NetworkManager.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//
//
import CoreLocation
import Foundation
import RxSwift
import RxRelay
import Alamofire

final class NetworkManager: NSObject {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let weatherDataRelay = BehaviorRelay<WeatherResponse?>(value: nil)
    var weatherDataObservable: Observable<WeatherResponse?> {
        return weatherDataRelay.asObservable()
    }
    private let apiKey = "3b2a9ba3c64b41399b8212812240805"
    
    // MARK: - Init
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D, numberOfDays: Int) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(coordinates.latitude),\(coordinates.longitude)&days=6"
        
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                self.weatherDataRelay.accept(weatherResponse)
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }
    
    func makeDataRequestForCityName(forCity cityName: String) -> Observable<WeatherResponse> {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityName)&days=6"
        return Observable.create { observer in
            AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weatherResponse):
                    observer.onNext(weatherResponse)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - Extension for location

extension NetworkManager: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        print("Updated location: \(location.coordinate)")
        makeDataRequest(forCoordinates: location.coordinate, numberOfDays: 6)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something wrong: \(error.localizedDescription)")
    }
}
