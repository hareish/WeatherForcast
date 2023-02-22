//
//  CityExtension.swift
//  what's the weather
//
//  Created by hermann kao on 02/10/2022.
//

import Foundation

enum WeatherCondition {
    case good
    case mean
    case bad
}

extension City: Equatable {
    static func == (left: City, right: City) -> Bool {
        return left.id == right.id
    }
}

extension City {
    var weatherIcon: String {
        if self.weather.current.weather.count > 0 {
            return self.weather.current.weather[0].icon
        }
        return "dayClearSky"
    }
    
    var currentWeatherCondition: WeatherCondition {
        let currentHourWeather = getCurrentHourWeather()
        if let conditionId = currentHourWeather?.weather.first?.id {
            switch conditionId {
            case (200...781):
                    return .bad
            case (800...802):
                return .good
            case (803...805):
                return .mean
            default:
                return .mean
            }
        }
        return .mean
    }

    var lottieAnimation: String {
        switch self.weatherIcon {
        case "01d":
            return "dayClearSky"
        case "01n":
            return "nightClearSky"
        case "02d":
            return "daysFewClouds"
        case "02n":
            return "nightFewClouds"
        case "03d":
            return "dayScatteredClouds"
        case "03n":
            return "nightScatteredClouds"
        case "04d":
            return "dayBorkenClouds"
        case "04n":
            return "dayBorkenClouds"
        case "09d":
            return "dayShowerRains"
        case "09n":
            return "nightShowerRains"
        case "10d":
            return "dayRain"
        case "10n":
            return "nightRain"
        case "11d":
            return "dayThunderStrom"
        case "11n":
            return "nightThunderStrom"
        case "12d":
            return "daySnow"
        case "12n":
            return "nightSnow"
        case "50d":
            return "dayMist"
        case "50n":
            return "nightMist"
        default:
            return "dayClearSky"
        }
    }

    var temperature: String {
        let currentHourWeather = getCurrentHourWeather()
        return getTempFor(temp: currentHourWeather?.temp ?? self.weather.current.temp)
    }
    
    var pressure: Int {
        let currentHourWeather = getCurrentHourWeather()
        return currentHourWeather?.pressure ?? self.weather.current.pressure
    }
    
    var windDirection: Int {
        let currentHourWeather = getCurrentHourWeather()
        return currentHourWeather?.windDeg ?? self.weather.current.windDeg
    }

    var conditions: String {
        if self.weather.current.weather.count > 0 {
            return self.weather.current.weather[0].main
        }
        return ""
    }

    var currentWeatherDescription: String {
        if self.weather.current.weather.count > 0 {
            return self.weather.current.weather[0].description
        }
        return ""
    }

    var windSpeed: String {
        let currentHourWeather = getCurrentHourWeather()
        return String (format: "%0.1f", currentHourWeather?.windSpeed ?? self.weather.current.windSpeed)
    }
    var humidity: String {
        let currentHourWeather = getCurrentHourWeather()
        return String (format: "%d%%", currentHourWeather?.humidity ?? self.weather.current.humidity)
    }

    var todayMinTemp: String {
        if(self.weather.daily.count > 0) {
            return getTempFor(temp: self.weather.daily[0].temp.min)
        }
        return ""
    }

    var todayMaxTemp: String {
        if(self.weather.daily.count > 0) {
            return getTempFor(temp: self.weather.daily[0].temp.max)
        }
        return ""
    }

    var rainChances: String {
        return String (format: "%0.0f%%", self.weather.current.dewPoint)
    }

    func getTempFor(temp: Double) -> String {
        return String (format: "%0.1f", temp)
    }
    
    func getCurrentHourWeather() -> Current? {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHourWeather = self.weather.hourly.first(where: {hourly in
            (Int(hourly.timeString) ?? 0) == hour
        })
        return currentHourWeather
    }
}
