//
//  OpenWeatherApi.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation
import Alamofire

class OpenWeatherApi {
    var baseUrl = "https://api.openweathermap.org/data/3.0"
    var apiKey = "e6385b3578f2b72cef4a2b0bae30f900"

    func getWeatherFromLatLong(lat: Double, long: Double, imperial: Bool = false, completion: @escaping (Weather) -> Void) {
        AF
            .request("\(baseUrl)/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&appid=\(apiKey)&units=\(imperial ? "imperial" :"metric")&lang=fr")
            .responseDecodable(of: Weather.self) { response in
                guard let weather = response.value else {
                    print("getWeatherFromLatLong Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                    return
                }
                completion(weather)
            }
    }

    func getWeatherFromLatLong(lat: Double, long: Double, imperial: Bool = false) async -> Weather {
        await withCheckedContinuation { continuation in
            getWeatherFromLatLong(lat: lat, long: long, imperial: imperial) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
