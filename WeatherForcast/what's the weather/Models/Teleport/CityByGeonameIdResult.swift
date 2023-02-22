//
//  CityByGeonameIdResult.swift
//  what's the weather
//
//  Created by hermann kao on 02/10/2022.
//

import Foundation

// MARK: - CityByGeonameIdResult
struct CityByGeonameIdResult: Codable {
    let links: CityByGeonameIdLinks
    let fullName: String
    let geonameid: Int
    let location: CityByGeonameIdLocation
    let name: String
    let population: Int

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case fullName = "full_name"
        case geonameid = "geoname_id"
        case location, name, population
    }
}

// MARK: - Links
struct CityByGeonameIdLinks: Codable {
    let cityAdmin1Division: CityByGeonameIdCity
    let cityAlternateNames: CityByGeonameIdCityAlternateNames
    let cityCountry, cityTimezone: CityByGeonameIdCity
    let curies: [CityByGeonameIdCury]
    let linksSelf: CityByGeonameIdCityAlternateNames

    enum CodingKeys: String, CodingKey {
        case cityAdmin1Division = "city:admin1_division"
        case cityAlternateNames = "city:alternate-names"
        case cityCountry = "city:country"
        case cityTimezone = "city:timezone"
        case curies
        case linksSelf = "self"
    }
}

// MARK: - City
struct CityByGeonameIdCity: Codable {
    let href: String
    let name: String
}

// MARK: - CityAlternateNames
struct CityByGeonameIdCityAlternateNames: Codable {
    let href: String
}

// MARK: - Cury
struct CityByGeonameIdCury: Codable {
    let href, name: String
    let templated: Bool
}

// MARK: - Location
struct CityByGeonameIdLocation: Codable {
    let geohash: String
    let latlon: Latlon
}

// MARK: - Latlon
struct LCityByGeonameIdatlon: Codable {
    let latitude, longitude: Double
}
