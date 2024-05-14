//
//  IconChange+Enum.swift
//  TryWeatherAppV2
//
//  Created by Алина on 09.05.2024.
//

import Foundation

enum IconChange: String {
    case overcast = "Overcast "
    case thunderstorm = "Thunderstorm"
    case rain  = "Rain"
    case snow = "Snow"
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainNearby = "Patchy rain nearby"
    case clear = "Clear"
    
    var emoji: String {
        switch self {
        case .overcast: return "🌧️"
        case .thunderstorm: return "⛈️"
        case .rain: return "🌧️"
        case .snow: return "❄️"
        case .sunny: return "☀️"
        case .cloudy: return "☁️"
        case .rainNearby: return "🌧️"
        case .clear: return "☀️"
        }
    }
}
