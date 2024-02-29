//
//  mapsApp.swift
//  maps
//
//  Created by Ezgi Hekim on 15.02.2024.
//

import SwiftUI
import GoogleMaps

@main
struct mapsApp: App {
    init(){
        GMSServices.provideAPIKey("AIzaSyDU3GlAjBQFgDAZSMRLIi_GGziUYG3bYd4")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
