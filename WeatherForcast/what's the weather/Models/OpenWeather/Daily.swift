import Foundation

// MARK: - Daily
struct Daily: Codable, Identifiable {
    var dt, sunrise, sunset, moonrise: Int
    var moonset: Int
    var moonPhase: Double
    var temp: Temp
    var feelsLike: FeelsLike
    var pressure, humidity: Int
    var dewPoint, windSpeed: Double
    var windDeg: Int
    var windGust: Double?
    var weather: [WeatherElement]
    var clouds: Int
    var pop: Double
    var uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi
    }

    init(
        _dt: Int = 0,
        _sunrise: Int = 0,
        _sunset: Int = 0,
        _moonrise: Int = 0,
        _moonset: Int = 0,
        _moonPhase: Double = 0.0,
        _temp: Temp = Temp(),
        _feelsLike: FeelsLike = FeelsLike(),
        _pressure: Int = 0,
        _humidity: Int = 0,
        _dewPoint: Double = 0.0,
        _windSpeed: Double = 0.0,
        _windDeg: Int = 0,
        _windGust: Double = 0.0,
        _weather: [WeatherElement] = [],
        _clouds: Int = 0,
        _pop: Double = 0.0,
        _uvi: Double = 0.0
    ) {
        dt = _dt
        sunrise = _sunrise
        sunset = _sunset
        moonrise = _moonrise
        moonset = _moonset
        moonPhase = _moonPhase
        temp = _temp
        feelsLike = _feelsLike
        pressure = _pressure
        humidity = _humidity
        dewPoint = _dewPoint
        windSpeed = _windSpeed
        windDeg = _windDeg
        windGust = _windGust
        weather = _weather
        clouds = _clouds
        pop = _pop
        uvi = _uvi
    }
}

extension Daily {
    var id: UUID {
        return UUID()
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.dt)))
    }
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.dt)))
    }
    
    var weatherIconName: String {
        if(self.weather.count == 0){
            return "sun.max.fill"
        }
        let icon = self.weather[0].icon
        switch icon {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d":
            return "cloud.fill"
        case "03n":
            return "cloud.fill"
        case "04d":
            return "cloud.fill"
        case "04n":
            return "cloud.fill"
        case "09d":
            return "cloud.drizzle.fill"
        case "09n":
            return "cloud.drizzle.fill"
        case "10d":
            return "cloud.heavyrain.fill"
        case "10n":
            return "cloud.heavyrain.fill"
        case "11d":
            return "cloud.bolt.fill"
        case "11n":
            return "cloud.bolt.fill"
        case "13d":
            return "cloud.snow.fill"
        case "13n":
            return "cloud.snow.fill"
        case "50d":
            return "cloud.fog.fill"
        case "50n":
            return "cloud.fog.fill"
        default:
            return "sun.max.fill"
        }
    }
}
