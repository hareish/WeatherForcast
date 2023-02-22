import Foundation

// MARK: - WeatherElement
struct WeatherElement: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case description = "description"
        case icon
    }

    init(
        _id: Int = 0,
        _main: String = "",
        _description: String = "",
        _icon: String = ""
    ) {
        id = _id
        main = _main
        description = _description
        icon = _icon
    }
}
