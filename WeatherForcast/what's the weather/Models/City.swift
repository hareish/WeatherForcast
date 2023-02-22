//
//  City.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation

class City: Codable, Identifiable {
    var id: Int
    var name: String
    var fullname: String
    var lat: Double
    var lon: Double
    var weather: Weather
    var backgroundUrl: String

    enum CodingKey: String {
        case name
        case lat
        case lon
        case weather
        case fullname
        case backgroundUrl
    }
    
    init(
        _id: Int = Int.random(in: 70..<500),
        _name: String = "",
        _lat: Double = 0.0,
        _lon: Double = 0.0,
        _weather: Weather = Weather(),
        _fullname: String = "",
        _backgroundUrl: String = ""
    ) {
        id = _id
        name = _name
        lat = _lat
        lon = _lon
        weather = _weather
        fullname = _fullname
        backgroundUrl = _backgroundUrl
    }
    
}
