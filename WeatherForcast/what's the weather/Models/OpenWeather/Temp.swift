import Foundation

// MARK: - Temp
struct Temp: Codable, Identifiable {
    var day, min, max, night: Double
    var eve, morn: Double

    init(
        _day: Double = 0.0,
        _min: Double = 0.0,
        _max: Double = 0.0,
        _night: Double = 0.0,
        _eve: Double = 0.0,
        _morn: Double = 0.0
    ) {
        day = _day
        min = _min
        max = _max
        night = _night
        eve = _eve
        morn = _morn
    }
}

extension Temp {
    var id: UUID {
        return UUID()
    }
}
