import Foundation

// MARK: - Current
struct Current: Codable, Identifiable {
    var dt: Int
    var sunrise, sunset: Int?
    var temp, feelsLike: Double
    var pressure, humidity: Int
    var dewPoint, uvi: Double
    var clouds, visibility: Int
    var windSpeed: Double
    var windDeg: Int
    var weather: [WeatherElement]
    var windGust, pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }

    init(
        _dt: Int = 0,
        _sunrise: Int = 0,
        _sunset: Int = 0,
        _temp: Double = 0.0,
        _feelsLike: Double = 0.0,
        _pressure: Int = 0,
        _humidity: Int = 0,
        _dewPoint: Double = 0.0,
        _uvi: Double = 0.0,
        _clouds: Int = 0,
        _visibility: Int = 0,
        _windSpeed: Double = 0.0,
        _windDeg: Int = 0,
        _weather: [WeatherElement] = [],
        _windGust: Double = 0.0,
        _pop: Double = 0.0
    ) {
        dt = _dt
        sunrise = _sunrise
        sunset = _sunset
        temp = _temp
        feelsLike = _feelsLike
        pressure = _pressure
        humidity = _humidity
        dewPoint = _dewPoint
        uvi = _uvi
        clouds = _clouds
        visibility = _visibility
        windSpeed = _windSpeed
        windDeg = _windDeg
        weather = _weather
        windGust = _windGust
        pop = _pop
    }
}

extension Current {
    var id: UUID {
        return UUID()
    }
    
    var temperature: String {
        return String (format: "%0.1f", self.temp)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "H"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.dt)))
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
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
