//
//  DailyWeatherView.swift
//  what's the weather
//
//  Created by Hareish Jeyakumar on 25/09/2022.
//

import SwiftUI

struct DailyWeatherView: View {
    @Binding var city: City

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Image(systemName: "calendar")
                    .font(.headline)
                Text("Prévisions sur 8 jours")
                    .font(.headline)
            }
                .foregroundColor(.white.opacity(0.65))
                .padding(.top, 6)
                .padding(.bottom, 3)
                .padding(.leading)
            Divider().overlay(.white.opacity(0.5))
            ForEach(city.weather.daily) { weather in
                VStack {
                    dailyCell(weather: weather)
                }
            }
        }
            .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white.opacity(0.1))
        )
            .padding()
    }
    private func dailyCell(weather: Daily) -> some View {
        HStack {
            Text (weather.dayString.capitalized)
            TemperatureGaugeView(
                min: weather.temp.min,
                max: weather.temp.max,
                current: weather.temp.day
            )
            Image(systemName: weather.weatherIconName)
        }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.top, 10)
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.blue.opacity(0.5), Color.blue]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .ignoresSafeArea()
            .overlay(
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        DailyWeatherView(city: .constant(City()))
                    }
                }
            }
        )
    }
}
