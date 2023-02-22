//
//  ErrorView.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Une erreur s'est produite").font(.title).padding(.bottom)
                Text(errorWrapper.error.localizedDescription).font(.headline)
                Text(errorWrapper.guidance).font(.caption).padding(.top)
                Spacer()
            }
            .padding()
            .cornerRadius(15)
            .background(.ultraThinMaterial)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem {
                    Button("Ignorer"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired,
                             guidance: "Vous pouvez ignorer cette erreur.")
    }
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
