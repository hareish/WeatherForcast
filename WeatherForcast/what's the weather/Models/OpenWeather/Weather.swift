import Foundation

// MARK: - Weather
struct Weather: Codable, Identifiable {
    var lat, lon: Double
    var timezone: String
    var timezoneOffset: Int
    var current: Current
    var hourly: [Current]
    var daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }

    init(
        _lat: Double = 0.0,
        _lon: Double = 0.0,
        _timezone: String = "",
        _timezoneOffset: Int = 0,
        _current: Current = Current(),
        _hourly: [Current] = [],
        _daily: [Daily] = []
    ) {
        lat = _lat
        lon = _lon
        timezone = _timezone
        timezoneOffset = _timezoneOffset
        current = _current
        hourly = _hourly
        daily = _daily
    }
}

extension Weather {
    var id: UUID {
        return UUID()
    }
}
