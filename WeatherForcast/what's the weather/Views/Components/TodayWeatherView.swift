//
//  TodayWeatherView.swift
//  what's the weather
//
//  Created by Hareish Jeyakumar℉ on 25/09/2022.
//

import SwiftUI

struct TodayWeatherView: View {
    @Binding var city: City
    @EnvironmentObject var helper: CityStore

    var body: some View {
        VStack(spacing: 10) {
            Text (city.fullname)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            Text (city.weather.current.dateString)
            HStack(spacing: 20) {
                LottieView(name: city.lottieAnimation)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    Text("\(city.temperature)°")
                        .font(.system(size: 42))
                    HStack {
                        Label("\(city.todayMinTemp)°", systemImage: "arrow.down")
                        Label("\(city.todayMaxTemp)°", systemImage: "arrow.up")
                    }
                }

            }
            HStack {
                Spacer()
                WidgetView(image: "wind", color: .red, title: "\(city.windSpeed) \(helper.imperial ? "mi/hr" : "m/s")")
                Spacer()
                WidgetView(image: "drop.fill", color: .blue, title: "\(city.humidity)")
                Spacer()
                WidgetView(image: "umbrella", color: .green, title: "\(city.rainChances)")
                Spacer()
            }

        }
            .padding()
            .foregroundColor(.white)

    }
    private func WidgetView(image: String, color: Color, title: String) -> some View {
        VStack {
            Image(systemName: image)
                .padding()
                .font(.title)
                .foregroundColor(color)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            Text(title)
        }
    }
}

struct TodayWeatherView_Previews: PreviewProvider {
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
                        TodayWeatherView(city: .constant(City())).environmentObject(CityStore())
                    }
                }
            }
        )
    }
}
