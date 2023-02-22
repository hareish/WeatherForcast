//
//  CityCardView.swift
//  what's the weather
//
//  Created by hermann kao on 04/10/2022.
//

import SwiftUI

struct CityCardView: View {
    @Binding var city: City
    @Binding var isCurrentCity: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text (city.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                if(isCurrentCity) { Text("Ma position") }
                Spacer()
                Text(city.currentWeatherDescription.capitalized)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(city.temperature)°")
                    .font(.system(size: 42))
                Spacer()
                HStack {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.down")
                        Text("\(city.todayMinTemp)°")
                    }
                        .foregroundColor(.white)
                        .font(.caption)
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.up")
                        Text("\(city.todayMaxTemp)°")
                    }
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
            .padding()
            .background(
            AsyncImage(url: URL(string: city.backgroundUrl))
            {
                image in
                image
                    .resizable()
                    .blur(radius: 1.5)
                    .overlay(Rectangle()
                        .fill(getGradient(condition: city.currentWeatherCondition).opacity(0.9)))
            } placeholder: {
                LinearGradient(
                    gradient: getGradient(condition: city.currentWeatherCondition),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            }.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        )
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
    }

    func getGradient(condition: WeatherCondition) -> Gradient {
        switch condition {
        case .good:
            return Gradient(
                colors: [Color.blue.opacity(0.5), Color.blue]
            )
        case .mean:
            return Gradient(
                colors: [Color.blue.opacity(0.5), Color.gray]
            )
        case .bad:
            return Gradient(
                colors: [Color.gray.opacity(0.1), Color.gray]
            )
        }
    }
}

struct CityCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CityCardView(
                city: .constant(City(
                    _name: "Londres", _backgroundUrl: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/San_Francisco_9q8yy_web-9a4042d87e@3x.jpg"
                    )),
                isCurrentCity: .constant(true)
            ).listRowInsets(EdgeInsets()).tint(.white)
        }.listStyle(PlainListStyle())
    }
}
