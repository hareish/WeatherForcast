//
//  HourlyWeatherView.swift
//  what's the weather
//
//  Created by Hareish Jeyakumar on 25/09/2022.
//

import SwiftUI

struct HourlyWeatherView: View {
    @Binding var city: City
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Text(city.currentWeatherDescription.capitalized)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 6)
                .padding(.bottom, 3)
                .padding(.leading)
            Divider().overlay(.white.opacity(0.5))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 10) {
                    ForEach(city.weather.hourly.prefix(24)) { weather in
                        VStack (spacing: 5) {
                            Text("\(weather.timeString)h").font(.caption)
                            Image(systemName: weather.weatherIconName).foregroundColor(.white)
                            Text("\(weather.temperature)°").font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.leading)
                    }
                }
            }.padding(.top)
                .padding(.bottom)
        }
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white.opacity(0.1))
        )
        .padding()
        
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
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
                        HourlyWeatherView(city: .constant(City()))
                    }
                }
            }
        )
    }
}
