import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    
    @Binding var origin: String
    @Binding var destination: String
    private let locationManager = CLLocationManager()
    
    func generatePlacesURL(location: String, radius: String, type: String, keyword: String, key: String) -> String {
        return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=\(keyword)&location=\(location)&radius=\(radius)&type=\(type)&key=\(key)"
    }
    
    var directionsURL: String {
        return generateDirectionsURL(origin: origin, destination: destination, apiKey: apiKeyRoute)
    }
    
    private var apiKeyRoute: String {
        guard let apiKeyRoute = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsRouteAPIKey") as? String else {
            fatalError("Google Maps API anahtarı bulunamadı.")
        }
        return apiKeyRoute
    }
    
    func generateDirectionsURL(origin: String, destination: String, apiKey: String) -> String {
        return "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
    }
    
    init(origin: Binding<String>, destination: Binding<String>) {
        self._origin = origin
        self._destination = destination
    }
    
    private func updateMapView(for mapView: GMSMapView, completion: @escaping([String]) -> Void){
        
        var placesURLs: [String] = []
        
        mapView.clear()
        guard let url = URL(string: directionsURL) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak mapView] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let routes = json["routes"] as? [[String: Any]] {
                        for route in routes {
                            if let legs = route["legs"] as? [[String: Any]] {
                                for leg in legs {
                                    if let steps = leg["steps"] as? [[String: Any]] {
                                        for step in steps {
                                            if let startLocation = step["start_location"] as? [String: Double],
                                               let endLocation = step["end_location"] as? [String: Double],
                                               let polyline = step["polyline"] as? [String: String], let _ = polyline["points"] {
                                              
                                                // Başlangıç ve bitiş konumlarını alın
                                                let startLat = startLocation["lat"] ?? 0.0
                                                let startLng = startLocation["lng"] ?? 0.0
                                                let endLat = endLocation["lat"] ?? 0.0
                                                let endLng = endLocation["lng"] ?? 0.0
                                                    
                                                let locationStart = "\(startLat),\(startLng)"
                                                let locationEnd = "\(endLat),\(endLng)"
                                                  
                                                let placesURL = generatePlacesURL(location: locationStart, radius: "1500", type: "restaurant", keyword: "cruise", key: apiKeyRoute)
                                                
                                                let placesURL2 = generatePlacesURL(location: locationEnd, radius: "1500", type: "restaurant", keyword: "cruise", key: apiKeyRoute)
                                                
                                                placesURLs.append(placesURL)
                                                placesURLs.append(placesURL2)
                                                
                                            }
                                            if let polyline = step["polyline"] as? [String: String], let points = polyline["points"] {
                                                DispatchQueue.main.async {
                                                    let path = GMSPath(fromEncodedPath: points)
                                                    let polyline = GMSPolyline(path: path)
                                                    polyline.strokeWidth = 4.0
                                                    polyline.strokeColor = .blue
                                                    polyline.map = mapView
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                completion(placesURLs)
                print(placesURLs)
                } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.17957363123993, longitude: 28.89126764689173, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        updateMapView(for: mapView) {placesURLs in
        }
    }
    
}
