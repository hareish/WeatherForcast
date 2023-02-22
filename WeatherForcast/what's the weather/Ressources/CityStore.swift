//
//  CityStore.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation
import SwiftUI
import CoreLocation

class CityStore: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cities: [City] = []
    @Published var currentCity: City = City()
    @Published var isCurrentCityAvailable: Bool = false
    @Published var isUpdatingCities: Bool = false
    @Published var imperial: Bool = false {
        didSet {
            updateAllCities()
        }
    }

    let locationManager = CLLocationManager()

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
            .appendingPathComponent("cities_list.data")
    }

    static func load() async throws -> [City] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }

    static func load(completion: @escaping (Result<[City], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let cities = try JSONDecoder().decode([City].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(cities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func save(cities: [City]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(cities: cities) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let citiesSaved):
                    continuation.resume(returning: citiesSaved)
                }
            }
        }
    }

    static func save(cities: [City], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(cities)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(cities.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func removeCity(city: City) {
        let filteredCities = cities.filter { (element: City) -> Bool in
            return !(element.id == city.id)
        }
        cities = filteredCities
    }

    func updateAllCities() {
        isUpdatingCities = true
        let openWeatherApi = OpenWeatherApi()
        if(cities.count == 0) {
            isUpdatingCities = false
            return
        }
        if(!currentCity.lat.isZero) {
            openWeatherApi.getWeatherFromLatLong(
                lat: currentCity.lat,
                long: currentCity.lon,
                imperial: imperial
            ) { result in self.currentCity.weather = result }
        }
        for index in 0..<cities.count {
            openWeatherApi.getWeatherFromLatLong(
                lat: cities[index].lat,
                long: cities[index].lon,
                imperial: imperial
            ) { result in
                self.cities[index].weather = result
                if(index == self.cities.count - 1) {
                    self.isUpdatingCities = false
                }
            }
        }
    }

    func createCityWithLatLon(lat: Double, lon: Double) async -> City {
        let teleportApi = TeleportApi()
        let openWeatherApi = OpenWeatherApi()
        let newCity = City()
        newCity.lat = lat
        newCity.lon = lon
        let nearest = await teleportApi.getNearestFromLatLong(lat: lat, long: lon)
        if(nearest.embedded.locationNearestCities.count > 0) {
            let nearestCity = nearest.embedded.locationNearestCities[0]
            let cityByUrl = await teleportApi.getCityByUrl(url: nearestCity.links.locationNearestCity.href)
            newCity.id = teleportApi.extractGeonameId(url: nearestCity.links.locationNearestCity.href)
            newCity.fullname = cityByUrl.fullName
            newCity.name = cityByUrl.name
        }
        if(nearest.embedded.locationNearestUrbanAreas.count > 0) {
            let nearestUrbanArea = nearest.embedded.locationNearestUrbanAreas[0]
            let urbanAreaImageByUrl = await teleportApi.getUrbanAreaImageByUrl(urbanAreaUrl: nearestUrbanArea.links.locationNearestUrbanArea.href)
            if(urbanAreaImageByUrl.photos.count > 0) {
                newCity.backgroundUrl = urbanAreaImageByUrl.photos[0].image.mobile
            }
        }
        let weather = await openWeatherApi.getWeatherFromLatLong(lat: lat, long: lon, imperial: imperial)
        newCity.weather = weather
        return newCity
    }

    func checkIfCurrentCityChanged(lat: Double, lon: Double) async -> Bool {
        if(currentCity.lat == lat && currentCity.lon == lon) { return false }
        let teleportApi = TeleportApi()
        let nearest = await teleportApi.getNearestFromLatLong(lat: lat, long: lon)
        if(nearest.embedded.locationNearestCities.count == 0) { return false }
        let nearestCity = nearest.embedded.locationNearestCities[0]
        let cityByUrl = await teleportApi.getCityByUrl(url: nearestCity.links.locationNearestCity.href)
        if(currentCity.fullname.compare(cityByUrl.fullName, options: .caseInsensitive) == .orderedSame) { return false }
        return true
    }

    /* Geolocation handlers */
    func startGeolocationHandler() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stopGeolocationHandler() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[0] as CLLocation
        if(locations.count == 0) { return }
        if(!(location.coordinate.latitude.isZero && location.coordinate.longitude.isZero)){
            self.isCurrentCityAvailable = true
        }
        Task {
            let isCityUpdated = await checkIfCurrentCityChanged(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            if(!isCityUpdated) { return }
            let updatedCity = await createCityWithLatLon(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            DispatchQueue.main.async { // Because changes must be published on main thread
                self.currentCity = updatedCity
                self.isCurrentCityAvailable = true
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        switch(authStatus) {
        case .notDetermined:
            isCurrentCityAvailable = false
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            isCurrentCityAvailable = false
            locationManager.startUpdatingLocation()
            break
        }
        return
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Erreur du gestionnaire de location \(error)")
    }
    /* End of Geolocation handlers */

    /* Icon Helpers */

    func getLottieAnimationFor(icon: String) -> String {
        switch icon {
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
    func getWeatherIcon(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image(systemName: "sun.max.fill")
        case "01n":
            return Image(systemName: "moon.fill")
        case "02d":
            return Image(systemName: "cloud.sun.fill")
        case "02n":
            return Image(systemName: "cloud.moon.fill")
        case "03d":
            return Image(systemName: "cloud.fill")
        case "03n":
            return Image(systemName: "cloud.fill")
        case "04d":
            return Image(systemName: "cloud.fill")
        case "04n":
            return Image(systemName: "cloud.fill")
        case "09d":
            return Image(systemName: "cloud.drizzle.fill")
        case "09n":
            return Image(systemName: "cloud.drizzle.fill")
        case "10d":
            return Image(systemName: "cloud.heavyrain.fill")
        case "10n":
            return Image(systemName: "cloud.heavyrain.fill")
        case "11d":
            return Image(systemName: "cloud.bolt.fill")
        case "11n":
            return Image(systemName: "cloud.bolt.fill")
        case "13d":
            return Image(systemName: "cloud.snow.fill")
        case "13n":
            return Image(systemName: "cloud.snow.fill")
        case "50d":
            return Image(systemName: "cloud.fog.fill")
        case "50n":
            return Image(systemName: "cloud.fog.fill")
        default:
            return Image(systemName: "sun.max.fill")

        }
    }

    /* End of icon helpers */

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        return formatter
    }()

    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "H"
        return formatter
    }()

    func getDateFromTimestamp(timestamp: Int) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }

    func getTimefor(timestamp: Int) -> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }

    func getTempFor(temp: Double) -> String {
        return String (format: "%0.1f", temp)
    }

    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
