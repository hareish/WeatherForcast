import Foundation

// MARK: - FeelsLike
struct FeelsLike: Codable, Identifiable {
    var day, night, eve, morn: Double
    init(
        _day: Double = 0.0,
        _night: Double = 0.0,
        _eve: Double = 0.0,
        _morn: Double = 0.0
    ) {
        day = _day
        night = _night
        eve = _eve
        morn = _morn
    }
}

extension FeelsLike {
    var id: UUID {
        return UUID()
    }
}
