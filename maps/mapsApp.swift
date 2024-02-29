import SwiftUI
import GoogleMaps
import GooglePlaces

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
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "PlacesKey") as? String {
            GMSPlacesClient.provideAPIKey(apiKey)
        } else {
            fatalError("Google Places API anahtarı bulunamadı.")
        }
    }
}
