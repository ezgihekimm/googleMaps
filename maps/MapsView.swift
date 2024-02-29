import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    
    @Binding var origin: String
    @Binding var destination: String
    private let locationManager = CLLocationManager()

        
    let apiKey = "AIzaSyAJgkDmNRh-v8wyw_2J1n_2AG1BrHQb0DM"
    
    var directionsURL: String {
        return generateDirectionsURL(origin: origin, destination: destination, apiKey: apiKey)
    }
    
    func generateDirectionsURL(origin: String, destination: String, apiKey: String) -> String {
        return "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
    }
    
    init(origin: Binding<String>, destination: Binding<String>) {
        self._origin = origin
        self._destination = destination
    }
    
    private func updateMapView(for mapView: GMSMapView) {
        
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
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.17957363123993, longitude: 28.89126764689173, zoom: 13.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.isMyLocationEnabled = true // Kullanıcının konumunu haritada göster
            return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        updateMapView(for: mapView)
    }
    
}
