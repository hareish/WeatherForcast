//
//  WindSpeedView.swift
//  what's the weather
//
//  Created by hermann kao on 06/10/2022.
//

import SwiftUI

struct WindSpeedView: View {
    @Binding var city: City

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "wind")
                Text("Vent").font(.headline)
                Spacer()
            }
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 6)
                .padding(.bottom, 3)
                .padding(.leading)
            Divider().overlay(.white.opacity(0.5))
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 100)
                .foregroundColor(.white.opacity(0.2))
                .overlay(
                ZStack {
                    ForEach(Array(stride(from: 0, to: 360, by: 20)), id: \.self) { i in
                        Circle()
                            .trim(from: 0.2499, to: 0.2519)
                            .stroke(style: StrokeStyle(lineWidth: 10))
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white.opacity(0.3))
                            .rotationEffect(.degrees(Double(i)))
                    }
                    ForEach(Array(stride(from: 0, to: 360, by: 90)), id: \.self) { i in
                        Circle()
                            .trim(from: 0.2490, to: 0.2520)
                            .stroke(style: StrokeStyle(lineWidth: 13))
                            .frame(width: 97, height: 97)
                            .foregroundColor(.white.opacity(0.5))
                            .rotationEffect(.degrees(Double(i)))
                    }
                    Circle()
                        .trim(from: 0.2499, to: 0.2501)
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(Double(city.windDirection)))
                    Text("N")
                        .offset(x: 0, y: -35)
                    Text("S")
                        .offset(x: 0, y: 35)
                    Text("O")
                        .offset(x: -35, y: 0)
                    Text("E")
                        .offset(x: 35, y: 0)
                    Circle()
                        .padding(.all, 23)
                        .foregroundColor(.white.opacity(0.1))
                    Text(city.windSpeed)
                }
                    .font(.caption)
                    .foregroundColor(.white)
            ).padding()
        }
            .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white.opacity(0.1))
        )
            .padding()
    }
}

struct WindSpeedView_Previews: PreviewProvider {
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
            VStack(alignment: .leading, spacing: 2) {
                WindSpeedView(
                    city: .constant(City())
                )
            }
                .padding()
        )
    }
}
