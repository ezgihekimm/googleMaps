import SwiftUI
import GoogleMaps

@main
struct mapsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String {
            GMSServices.provideAPIKey(apiKey)
        } else {
            fatalError("Google Maps API anahtarı bulunamadı.")
        }
    }
}
