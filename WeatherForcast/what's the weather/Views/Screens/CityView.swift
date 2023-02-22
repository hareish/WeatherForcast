//
//  CityView.swift
//  what's the weather
//
//  Created by Hareish Jeyakumar on 25/09/2022.
//

import SwiftUI

struct CityView: View {
    @Binding var city: City
    @Binding var isCurrent: Bool
    @EnvironmentObject private var store: CityStore

    init(
        isCurrent: Binding<Bool> = .constant(false),
        city: Binding<City>
    ) {
        _isCurrent = isCurrent // Default value for the binding
        _city = city
    }

    var body: some View {
            if(city.lon.isZero) {
            VStack(spacing: 50) {
                if(!store.isCurrentCityAvailable && isCurrent) {
                    Image(systemName: "location")
                        .font(.system(size: 64))
                        .foregroundColor(.white.opacity(0.5))
                    Text("Autorisez la géolocation pour obtenir la meteo à votre emplacement actuel")
                        .foregroundColor(.white.opacity(0.75))
                        .font(.title)
                        .multilineTextAlignment(.center)
                } else {
                    ProgressView(label: { Text("Chargement de la ville...") })
                        .tint(.white)
                        .controlSize(.large)
                }
            }
        } else {
            ScrollView(showsIndicators: false) {
                VStack {
                    TodayWeatherView(city: $city)
                        .padding()
                    HourlyWeatherView(city: $city)
                    DailyWeatherView(city: $city)
                    CityDetailsView(city: $city)
                }
            }
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.blue.opacity(0.5), Color.blue]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .overlay(
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        CityView(
                            isCurrent: .constant(true),
                            city: .constant(City())).environmentObject(CityStore())
                    }
                }
            }
        )
    }
}
