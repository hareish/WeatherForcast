//
//  MapView.swift
//  what's the weather
//
//  Created by hermann kao on 02/10/2022.
//

import SwiftUI

struct MapView: View {
    @State var openWeatherMapUrl: String = "https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature"
    @State var webviewWorkState = WebView.WorkState.initial
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            WebView(workState: $webviewWorkState, urlString: $openWeatherMapUrl).edgesIgnoringSafeArea(.bottom)
        }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("OK") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Carte méteo").font(.headline)
            }
            ToolbarItem(placement: .primaryAction) {
                if(webviewWorkState == WebView.WorkState.working) {
                    ProgressView()
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
